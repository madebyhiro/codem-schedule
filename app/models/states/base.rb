module States
  module Base
    def self.included(base)
      base.class_eval do
        after_initialize  :set_initial_state
        after_create      { enter(initial_state) }
      end
    end
    
    def initial_state
      Job::Scheduled
    end
    
    def enter(state, parameters={})
      update_attributes :state => state
      self.send("enter_#{state}", parameters)
      self
    end
    
    protected
      def set_initial_state
        self.state ||= Job::Scheduled
      end

      def enter_scheduled(params)
        Jobs::ScheduleJob.new(self, params).perform
      end

      def enter_transcoding(params)
        update_attributes :host_id => params['host_id'],
                          :remote_job_id => params['job_id'],
                          :transcoding_started_at => Time.current
      end
      
      def enter_failed(params)
        update_attributes :message => params[:message]
      end
  end
end
