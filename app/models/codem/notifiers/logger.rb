module Codem
  module Notifiers
    class Logger
      def notify(state, job)
        logger.info format_log_message(state, job) if logging_enabled?
      end

      def format_log_message(state, job)
        "#{Time.now}: Job #{job.id} entered state #{state.capitalize}"
      end
      
      def logger
        @logger ||= ::Logger.new(log_file_path)
      end
      
      def logging_enabled?
        Rails.env != 'test'
      end
      
      protected
        def log_file_path
          File.join(Rails.root, 'log', 'job_notifier.log')          
        end
    end
  end
end