module Jobs
  module Notifications
    mattr_accessor :default_responders
    @@default_responders = [Jobs::Notifiers::Logger.new]
    
    def self.included(base)
      base.class_eval do
        cattr_accessor :default_responders
        @@default_responders = Jobs::Notifications.default_responders
        
        cattr_accessor :responders
        @@responders = Array(@@default_responders)
      end
    end
    
    def add_responder(responder, responding_to=:all)
      self.class.responders << [responder, responding_to]
    end
    
    def notify_responders
      self.class.responders.each do |responder, responding_to|
        begin
          if [:all, state.to_sym].include?(responding_to)
            responder.notify(state, self)
            Rails.logger.info "Notified #{responder} of #{state} for #{self}"
          end
        rescue => e
          log_notifier_error(e, responder)
        end
      end
    end
    
    private
      def log_notifier_error(e, responder)
        Rails.logger.warn "\n" + "*** Codem Notifier error"
        Rails.logger.warn "Responder #{responder} raised an error while notifying #{state} for #{self}: "
        Rails.logger.warn e.message + "\n"
        Rails.logger.warn e.backtrace.join("\n") + "\n"
      end
  end
end
