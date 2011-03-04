module Codem
  module States
    def self.included(base)
      base.class_eval do
        after_create { enter(initial_state) }
      end
    end

    def enter(state, parameters={})
      update_attributes :state => state

      method = "enter_#{state}"
      self.send(method, parameters)
    end

    def initial_state
      Codem::Scheduled
    end

    protected
      def enter_scheduled(parameters)
        Delayed::Job.enqueue Codem::Jobs::ScheduleJob.new(self, parameters)
      end
      
      def enter_transcoding(parameters)
        update_attributes :remote_jobid => parameters['job_id'],
                          :transcoding_started_at => Time.now
      end

      def enter_on_hold(parameters)
        unless state == Codem::OnHold
          Codem::Jobs::Base.remove_all_for(self)
          Delayed::Job.enqueue Codem::Jobs::OnHoldJob.new(self, parameters)
        end
      end
      
      def enter_complete(parameters)
        update_attributes :progress => '100.00',
                          :completed_at => Time.now
      end
      
      def enter_failed(parameters)
        Codem::Jobs::Base.remove_all_for(self)
      end
  end
end
