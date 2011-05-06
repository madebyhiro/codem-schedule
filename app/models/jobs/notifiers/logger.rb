module Jobs
  module Notifiers
    class Logger
      cattr_accessor :log_file_path, :logging_enabled
      
      @@log_file_path   = File.join(Rails.root, 'log', "#{Rails.env}_job_notifier.log")
      @@logging_enabled = true
      
      def notify(state, job)
        log format_log_message(state, job) if self.class.logging_enabled
      end

      def format_log_message(state, job)
        "#{Time.now}: Job #{job.id} entered state #{state.capitalize}"
      end
      
      def log(message)
        logger.info message
      end
      
      def logger
        @logger ||= ::Logger.new(self.class.log_file_path)
      end
    end
  end
end
