class Schedule
  class << self
    def run!
      count = 0

      jobs = to_be_updated_jobs

      jobs.each do |job|

        job.with_lock(true) do
          if job.state == Job::Scheduled
            schedule_job(job)
          else
            update_job(job)
          end
        end

      end
     
      jobs.size
    end

    def to_be_updated_jobs
      Job.where(state: [ Job::Scheduled, Job::Processing, Job::OnHold ]).order('created_at')
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
          job.update_attributes :progress => attrs['progress'],
                                :duration => attrs['duration'],
                                :filesize => attrs['filesize']

          if job.state != attrs['status']
            job.enter(attrs['status'], attrs)
          end

        else
          job.enter(Job::OnHold)
        end

        job
      end

      def schedule_job(job)
        for host in Host.with_available_slots
          if attrs = Transcoder.schedule(:host => host, :job => job)

            job.update_attributes :host_id => attrs['host_id'],
                                  :remote_job_id => attrs['job_id'],
                                  :transcoding_started_at => Time.current

            job.enter(Job::Processing, attrs)

            break
          end
        end
      end
  end
end
