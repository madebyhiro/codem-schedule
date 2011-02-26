module Codem
  module Notifiers
    autoload :Logger,   'codem/notifiers/logger'
    autoload :History,  'codem/notifiers/history'

    def self.included(base)
      base.class_eval do
        alias_method_chain :enter, :notify
      end
    end

    def enter_with_notify(state, parameters={})
      enter_without_notify(state, parameters)
      notify_responders
    end
        
    attr_accessor_with_default :responders, [Codem::Notifiers::Logger.new, Codem::Notifiers::History.new]

    def add_responder(responder, responding_to=:all)
      responders << [responder, responding_to]
    end
    
    def notify_responders
      responders.each do |responder, responding_to|
        responder.notify(state, self)
      end
    end
    
  end
end