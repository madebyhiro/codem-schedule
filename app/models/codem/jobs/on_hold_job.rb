module Codem
  module Jobs
    class OnHoldJob < Codem::Jobs::Base
      def perform
        job.host.update_status
        
        if job.host.available
          job.enter(Codem::Queued)
        else
          reschedule
        end
      end
    end
  end
end