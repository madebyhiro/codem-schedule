class DashboardController < ApplicationController
  def show
    @history = History.new(params[:period])

    recent_jobs = Job.recents.limit(10)

    @scheduled_jobs  = recent_jobs.scheduled
    @processing_jobs = recent_jobs.processing
    @failed_jobs     = recent_jobs.failed
  end
end
