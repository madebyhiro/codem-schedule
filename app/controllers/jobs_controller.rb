class JobsController < ApplicationController
  respond_to :json, :html
  
  def index
    @history = History.new(params[:period])
    @jobs = Job.list(:page => params[:page])
  end
  
  def completed
    @history = History.new(params[:period])
    @jobs = Job.completed.list(:page => params[:page])
  end
  
  def failed
    @history = History.new(params[:period])
    @jobs = Job.failed.list(:page => params[:page])
  end
  
  def new
    @job = Job.new
  end
  
  def create
    @job = Job.new(params[:job])
    if @job.save
      flash[:notice] = "Job has been created"
      redirect_to jobs_path
    else
      flash[:error] = "Job could not be saved"
      render :action => "new"
    end
  end
  
  def show
    @job = Job.find(params[:id], :include => [:host, :preset, :state_changes])
  end
  
  def update
    attributes = Crack::JSON.parse(request.body.read)
    Rails.logger.debug '*'*20
    Rails.logger.debug attributes
    render :nothing => true
  end
end
