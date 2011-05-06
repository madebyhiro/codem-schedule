class Api::JobsController < Api::ApiController
  def index;        jobs_index(Job.scoped); end
  def scheduled;    jobs_index(Job.scheduled); end
  def accepted;     jobs_index(Job.accepted); end
  def processing;   jobs_index(Job.processing); end
  def on_hold;      jobs_index(Job.on_hold); end
  def success;      jobs_index(Job.success); end
  def failed;       jobs_index(Job.failed); end
  
  def create
    job = Job.from_api(params, :callback_url => lambda { |job| api_job_url(job) })
    if job.valid?
      response.headers["X-State-Changes-Location"] = api_state_changes_url(job)
      respond_with job, :location => api_job_url(job) do |format|
        format.html { redirect_to jobs_path }
      end
    else
      respond_with job do |format|
        format.html { @job = job; render "/jobs/new"}
      end
    end
  end
  
  def update
    job = Job.find(params[:id])
    job.enter(params[:status], params)
    respond_with job, :location => api_job_url(job)
  end
  
  def show
    job = Job.find(params[:id])
    job.update_status
    respond_with job
  end
  
  private
    def jobs_index(jobs)
      jobs = jobs.page(params[:page]).per(20)
      jobs.select(&:unfinished?).map(&:update_status)
      respond_with jobs
    end
end
