Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.max_attempts = 10_000

Delayed::Worker.logger = ActiveSupport::BufferedLogger.new("log/#{Rails.env}_delayed_jobs.log", Rails.logger.level)
Delayed::Worker.logger.auto_flushing = 1