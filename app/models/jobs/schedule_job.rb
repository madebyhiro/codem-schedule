module Jobs
  class ScheduleJob
    attr_reader :job
    
    def initialize(job, params={})
      @job = job
    end

    def perform
      for host in available_hosts
        return true if schedule_job_at(host)
      end
      reschedule
    end
    
    def schedule_job_at(host)
      Transcoder.schedule(:host => host, :job => job)
    end
    
    def available_hosts
      Host.with_available_slots
    end
    
    def reschedule
    end
  end
end
