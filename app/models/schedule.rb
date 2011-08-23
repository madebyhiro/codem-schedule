class Schedule
  class << self
    def run!
      jobs.collect do |job| 
        update_job(job)
      end
    end
  
    def jobs
      Job.unfinished.order("created_at")
    end
  
    def update_progress(job)
      if job.state == Job::Processing
        attrs = Transcoder.job_status(job)
        job.enter(attrs['status'], attrs)
      end
      job
    end
  
    private
      def update_job(job)
        if job.state == Job::Scheduled || job.state == Job::OnHold
          schedule_job(job)
        else
    
          if attrs = Transcoder.job_status(job)
            job.enter(attrs['status'], attrs)
          else
            job.enter(Job::OnHold)
          end
  
        end
    
        job
      end
    
      def schedule_job(job)
        for host in Host.with_available_slots
          if attrs = Transcoder.schedule(:host => host, :job => job)
            job.enter(Job::Accepted, attrs)
            break
          end
        end
      end
  end
end