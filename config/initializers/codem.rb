Codem::Notifiers.default_responders << Codem::Notifiers::Email.new(JobsMailer)

#Codem::Notifiers::Logger.log_file_path = File.join(Rails.root, 'log', 'job_notifier.log')
#Codem::Notifiers::Logger.logging_enabled = true