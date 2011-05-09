class Runner
  def self.schedule!
    jobs.collect do |job| 
      job.update_status
    end
  end
  
  def self.jobs
    Job.unfinished.order("created_at")
  end
end
