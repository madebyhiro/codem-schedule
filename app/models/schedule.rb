require File.join(Rails.root, 'lib', 'retryable')

class Schedule
  class RetrySchedulingError < StandardError ; end

  class << self
    def run!
      count = 0

      to_be_scheduled_jobs.each do |job|
        job.lock! do
          schedule_job(job)
          count += 1
        end
      end
      
      to_be_updated_jobs.each do |job|
        job.lock! do
          update_job(job)
          count += 1
        end
      end
     
      count
    end

    def to_be_scheduled_jobs
      Job.scheduled.unlocked.order("priority DESC, created_at ASC").limit(get_available_slots)
    end
    
    def to_be_updated_jobs
      Job.unfinished.unlocked.order('priority DESC, created_at')
    end
  
    def update_progress(job, attrs=false)
      attrs ||= Transcoder.job_status(job)

      if attrs
        job.update_attributes :progress => attrs['progress'],
          :duration => attrs['duration'],
          :filesize => attrs['filesize']
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

    def schedule_strategy
      ScheduleStrategies::Weighted
    end
    
    def retry_attempts
      3
    end

    private
    def update_job(job)
      if attrs = Transcoder.job_status(job)
        if attrs['status'] == Job::Processing && job.state == Job::Processing
          update_progress(job, attrs)
        else
          job.enter(attrs['status'], attrs)
        end
      else
        job.enter(Job::OnHold)
      end

      job
    end

    def schedule_job(job)
      strategy = schedule_strategy.new

      begin
        Retryable.attempt(tries: retry_attempts) do                         # Retry this block `retry_attempts' times
          strategy.hosts.each do |host|                                           # for each host in the current scheduling strategy,
            if attrs = Transcoder.schedule(:host => host, :job => job)                # try to schedule the host, and if the job was scheduled
              job.enter(Job::Accepted, attrs)                                             # enter accepted state,
              return                                                                      # and break
            end
          end
          raise RetrySchedulingError                                              # or raise a RetryScheduling error to retry
        end
      rescue RetrySchedulingError => e                                      # rescue after `retry_attempts' retries to continue normal flow
      end
    end
  end
end
