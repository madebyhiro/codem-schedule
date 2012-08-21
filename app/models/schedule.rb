class Schedule
  class << self
    def run!
      count = 0

      to_be_scheduled_jobs.each do |job|
        schedule_job(job)
        count += 1
      end
      
      to_be_updated_jobs.each do |job|
        update_job(job)
        count += 1
      end
     
      count
    end

    def to_be_scheduled_jobs
      Job.scheduled.order("created_at ASC").limit(get_available_slots)
    end
    
    def to_be_updated_jobs
      Job.unfinished.order('created_at')
    end
  
    def update_progress(job)
      if job.state == Job::Processing
        if attrs = Transcoder.job_status(job)
          job.enter(attrs['status'], attrs)
        end
      end
      job
    end

    def get_available_slots
      sum = 0
      Host.all.each do |h| 
        h.update_status
        sum += h.available_slots
      end
      sum
    end

    private
    def update_job(job)
      if attrs = Transcoder.job_status(job)
        job.enter(attrs['status'], attrs)
      else
        job.enter(Job::OnHold)
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
