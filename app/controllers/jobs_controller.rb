class JobsController < ApplicationController
  def index
    @jobs = Job.recents(params[:page])
  end
  
  def show
    @job = Job.find(params[:id])
    @job.update_status
  end
  
  def new
  end
end
