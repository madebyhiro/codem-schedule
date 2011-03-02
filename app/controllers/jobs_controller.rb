class JobsController < ApplicationController
  respond_to :json, :html

  def index
    @history = History.new(params[:period])
    @jobs = Job.list(:page => params[:page])
    respond_with @jobs
  end

  def transcoding
    @jobs = Job.transcoding.list(:page => params[:page])
    respond_with @jobs
  end
  
  def completed
    @jobs = Job.completed.list(:page => params[:page])
    respond_with @jobs
  end
  
  def failed
    @jobs = Job.failed.list(:page => params[:page])
    respond_with @jobs
  end
  
  def new
    @job = Job.new
  end
  
  def create
    @job = Job.new(params[:job])
    if @job.save
      flash[:notice] = "Job has been created"
    else
      flash[:error] = "Job could not be saved"
    end
    respond_with @job
  end
  
  def show
    @job = Job.find(params[:id], :include => [:host, :preset, :state_changes])
    respond_with @job
  end
  
  def update
    attributes = Crack::JSON.parse(request.body.read)
    
    if job = Job.find_by_remote_jobid(attributes['id'])
      job.update_attributes :last_status_message => attributes['message']
      
      case attributes['status']
        when 'failed'
          job.enter(:failed, attributes)
        when 'success'
          job.enter(:complete, attributes)
      end
      
      respond_with job
    else
      render :nothing => true, :status => :not_found
    end
  end
end
