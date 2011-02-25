module Codem
  module Jobs
    class Base
      include HTTParty
      format :json

      attr_accessor :job, :parameters

      def initialize(job=nil, parameters={})
        @job        = job
        @parameters = parameters
      end
      
      def job_status(job)
        self.class.get("#{job.host.address}/jobs/#{job.remote_jobid}")
      end
      
      def display_name
        self.class.name.demodulize
      end
      
      def reschedule(options={})
        Delayed::Job.enqueue self.class.new(job, parameters), options
      end
      
      def error(delayed_job, exception)
        # host is dead?
        job.enter(:scheduled)
        job.host.update_status
      end
      
      def failure
        reschedule
      end
    end
  end
end