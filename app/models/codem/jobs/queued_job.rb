module Codem
  module Jobs
    class QueuedJob < Codem::Jobs::Base
      def perform
        status = job_status(job)
        
        if status['status'] == 'processing'
          job.enter(:transcoding, status)
        elsif status.empty?
          job.enter(:complete)
        else
          reschedule :run_at => 5.seconds.from_now
        end
      end
    end
  end
end