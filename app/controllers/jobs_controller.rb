class JobsController < ApplicationController
  def index
    @history = History.new(params[:period])
    @jobs    = Job.recents(params[:page])
    @jobs.map(&:update_status)
  end
  
  def show
    @job = Job.find(params[:id], :include => [:host, :preset, :state_changes, :notifications])
    @job.update_status
  end
  
  def new
  end
end
