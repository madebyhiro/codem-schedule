class JobsController < ApplicationController
  def index
    @history = History.new(params[:period])
    @jobs    = Job.recent
  end
  
  def new
    @job = Job.new
  end
  
  def create
    @job = Job.new(params[:job])
    if @job.save
      redirect_to @job, :notice => "Job has been created"
    else
      render :action => "new"
    end
  end
end
