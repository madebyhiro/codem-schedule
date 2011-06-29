class JobsController < ApplicationController
  def index
    @history = History.new(params[:period])
    @jobs    = Job.recents(params[:page])
    @jobs.collect { |j| Schedule.update_progress(j) }
  end
  
  def show
    @job = Job.find(params[:id], :include => [:host, :preset, :state_changes, :notifications])
  end
  
  def new
  end
  
  def retry
    job = Job.find(params[:id])
    job.enter(Job::Scheduled)
    redirect_to jobs_path
  end
end
