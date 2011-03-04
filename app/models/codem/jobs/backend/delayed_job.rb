module Codem
  module Jobs
    module Backend
      class DelayedJob
        def enqueue(background_job, options)
          Delayed::Job.enqueue(background_job, options)
        end
      end
    end
  end
end