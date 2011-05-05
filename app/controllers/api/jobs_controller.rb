class Api::JobsController < Api::ApiController
  def index
    jobs_index(Job.scoped)
  end

  def scheduled
    jobs_index(Job.scheduled)
  end
  
  def transcoding
    jobs_index(Job.transcoding)
  end
  
  def on_hold
    jobs_index(Job.on_hold)
  end
  
  def completed
    jobs_index(Job.completed)
  end
  
  def failed
    jobs_index(Job.failed)
  end
  
  def create
    job = Job.from_api(params)
    job.save
    respond_with job, :location => api_job_url(job)
  end
  
  def update
    job = Job.find(params[:id])
    respond_with job, :location => api_job_url(job)
  end
  
  def show
    job = Job.find(params[:id])
    respond_with job
  end
  
  private
    def jobs_index(jobs)
      respond_with jobs.page(params[:page]).per(20)
    end
end
