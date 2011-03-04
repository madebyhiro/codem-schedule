module Codem
  module Jobs
    module Backend
      class DelayedJob
        def enqueue(background_job, options)
          options[:run_at] ||= 1.second.from_now
          Delayed::Job.enqueue(background_job, options)
        end
      end
    end
  end
end