module States
  module Base
    def self.included(base)
      base.class_eval do
        after_create      { enter(initial_state) }
        after_initialize  :set_initial_state
      end
    end
    
    def initial_state
      Job::Scheduled
    end
    
    def enter(state, parameters={})
      update_attributes :state => state
      self.send("enter_#{state}", parameters)
    end
    
    def enter_scheduled(params)
    end
    
    private
      def set_initial_state
        self.state ||= Job::Scheduled
      end
  end
end