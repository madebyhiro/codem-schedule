module Codem
  module Jobs
    class TranscodeJob < Codem::Jobs::Base
      def perform
        status = job_status(job)

        if status.empty?
          job.enter(:complete)
        else
          job.update_attributes :progress => status['progress'], 
                                :duration => status['duration'], 
                                :filesize => status['filesize']

          reschedule :run_at => 3.seconds.from_now
        end
      end
    end
  end
end