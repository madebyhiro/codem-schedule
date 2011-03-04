module Codem
  module Jobs
    include Backend::Base
    
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
        Codem::Jobs.queue self.class.new(job, parameters), options
      end
      
      def failure
        reschedule
      end
    end
  end
end