module Codem
  module States
    def self.included(base)
      base.class_eval do
        after_create { enter(initial_state) }
      end
    end

    def enter(state, parameters={})
      update_attributes :state => state

      method = "enter_#{state}".to_sym
      self.send(method, parameters)
      
      notify_responders
    end

    def initial_state
      :scheduled
    end

    protected
      def enter_scheduled(parameters)
        Delayed::Job.enqueue Codem::Jobs::ScheduleJob.new(self)
      end
      
      def enter_queued(parameters)
        update_attributes :remote_jobid => parameters['job_id']
        Delayed::Job.enqueue Codem::Jobs::QueuedJob.new(self)
      end
      
      def enter_transcoding(parameters)
        Delayed::Job.enqueue Codem::Jobs::TranscodeJob.new(self, parameters)
      end
      
      def enter_complete(parameters)
      end        
  end
end
