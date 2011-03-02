module Codem
  module Jobs
    class QueuedJob < Codem::Jobs::Base
      def perform
        status = job_status(job)
        
        if status['status'] == 'processing'
          job.enter(Codem::Transcoding, status)
        else
          reschedule
        end
      end
    end
  end
end