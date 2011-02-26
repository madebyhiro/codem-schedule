class JobsMailer < ActionMailer::Base
  default :from => "codem@codem-scheduler.com"
  
  def complete(job)
    @job = job
    mail(:to => recipients)
  end
  
  def recipients
    %w(loop@superinfinite.com)
  end
end
