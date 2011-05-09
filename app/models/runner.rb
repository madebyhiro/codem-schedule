class Runner
  def self.schedule!
    jobs.each do |job| 
      job.enter(job.state)
    end
  end
  
  def self.jobs
    Job.scheduled + Job.on_hold + Job.processing
  end
end
