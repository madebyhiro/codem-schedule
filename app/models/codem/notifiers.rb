module Codem
  module Notifiers
    autoload :Logger, 'codem/notifiers/logger'
    autoload :History, 'codem/notifiers/history'
    
    attr_accessor_with_default :responders, []
    
    def initialize(*args)
      super(*args)
      add_responder Codem::Notifiers::Logger.new
      add_responder Codem::Notifiers::History.new
    end
    
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