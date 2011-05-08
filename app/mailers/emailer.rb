class Emailer < ActionMailer::Base
  def state_change(opts)
    @job = opts[:job]
    mail(:to => opts[:to], 
         :subject => "Codem Notification: Job #{@job.id} has entered #{opts[:state]}")
  end
end
