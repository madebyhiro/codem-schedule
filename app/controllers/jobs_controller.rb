class JobsController < ApplicationController
  def index
    @history = History.new(params[:period])
    @jobs    = Job.recents(params[:page])
    @jobs.need_update.map(&:update_status)
  end
  
  def show
    @job = Job.find(params[:id], :include => [:host, :preset, :state_changes, :notifications])
    @job.update_status if @job.needs_update?
  end
  
  def new
  end
  
  def retry
    job = Job.find(params[:id])
    job.enter(Job::Scheduled)
    redirect_to jobs_path
  end
end
