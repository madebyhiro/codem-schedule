module Delayed
  module Backend
    module Base
      def reschedule_at
        self.class.db_time_now + 5
      end
    end
  end
end

Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.max_attempts = 10_000