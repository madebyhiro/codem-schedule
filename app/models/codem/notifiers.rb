module Codem
  module Notifiers
    autoload :Logger,   'codem/notifiers/logger'
    autoload :History,  'codem/notifiers/history'

    mattr_accessor :default_responders
    @@default_responders = [Codem::Notifiers::Logger.new, Codem::Notifiers::History.new]
    
    def self.included(base)
      base.class_eval do
        alias_method_chain :enter, :notify

        cattr_accessor :default_responders
        @@default_responders = Codem::Notifiers.default_responders
        
        cattr_accessor :responders
        @@responders = Array(@@default_responders)
      end
    end

    def enter_with_notify(state, parameters={})
      enter_without_notify(state, parameters)
      notify_responders
    end
        
    def add_responder(responder, responding_to=:all)
      self.class.responders << [responder, responding_to]
    end
    
    def notify_responders
      self.class.responders.each do |responder, responding_to|
        begin
          responder.notify(state, self)
          Rails.logger.info "Notified #{responder} of #{state} for #{self}"
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