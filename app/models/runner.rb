class Runner
  def self.schedule!
    jobs.collect do |job| 
      job.update_status
    end
  end
  
  def self.jobs
    Job.scheduled + Job.on_hold + Job.processing
  end
end
