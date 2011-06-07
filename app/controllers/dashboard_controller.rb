class DashboardController < ApplicationController
  def show
    recent_jobs = Job.recents.limit(10)
    recent_jobs.map(&:update_status)
    
    @scheduled_jobs  = recent_jobs.scheduled
    @processing_jobs = recent_jobs.processing
    @failed_jobs     = recent_jobs.failed
  end
end
