class Api::JobsController < Api::ApiController
  def index
    respond_with Job.all
  end
  
  def create
    job = Job.from_api(params)
    job.save
    respond_with job, :location => api_job_url(job)
  end
  
  def show
    job = Job.find(params[:id])
    respond_with job
  end
  
  def scheduled
    respond_with Job.scheduled
  end
  
  def transcoding
    respond_with Job.transcoding
  end
  
  def on_hold
    respond_with Job.on_hold
  end
  
  def completed
    respond_with Job.completed
  end
  
  def failed
    respond_with Job.failed
  end
end
