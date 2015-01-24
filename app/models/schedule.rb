class Schedule
  class << self
    def run!
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
        limit = Host.all.length;
        Job.where(state: [Job::Processing, Job::OnHold, Job::Scheduled]).order('state desc').limit(limit);
    end

    def available_slots
      sum = 0
      Host.all.each do |h|
        h.update_status
        sum += h.available_slots
      end
      sum
    end

    private

    def update_job(job)
      attrs = Transcoder.job_status(job)
      if attrs
        job.update_attributes(
          progress: attrs['progress'],
          duration: attrs['duration'],
          filesize: attrs['filesize']
        )

        job.enter(attrs['status'], attrs) if job.state != attrs['status']

      else
        job.enter(Job::OnHold)
      end

      job
    end

    def schedule_job(job)
      Host.with_available_slots.each do |host|
        attrs = Transcoder.schedule(host: host, job: job)
        next unless attrs

        job.update_attributes(
          host_id: attrs['host_id'],
          remote_job_id: attrs['job_id'],
          transcoding_started_at: Time.current
        )

        job.enter(Job::Processing, attrs)

        break
      end
    end
  end
end
