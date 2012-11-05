# = Jobs controller
#
# == States
# A job can be in one of the following states:
#
# <tt>scheduled</tt>::   Scheduled to be sent to the Transcoder instances
# <tt>accepted</tt>::    Accepted by a Transcoder instance, waiting to start processing
# <tt>processing</tt>::  Being processed by a Transcoder Instance
# <tt>\on_hold</tt>::    Waiting for a Transcoder to become responsive again
# <tt>success</tt>::     Successfully completed
# <tt>failed</tt>::      An error occurred
#
# == Pagination
# For methods that use pagination, a <tt>page</tt> parameters can be sent to display that particular page of jobs.
# Jobs are paginated with 25 jobs per page.
# For example, to get the 5th page of successfully completed jobs, use:
#   http://host.com/api/jobs/completed?page=5
class Api::JobsController < Api::ApiController
  respond_to :rss, :only => [:index, :scheduled, :accepted, :processing, :on_hold, :success, :failed]
  # == Returns a list of jobs regardless of state.
  # This method uses pagination.
  def index;        jobs_index(Job.scoped); end
  # == Returns a list of scheduled jobs
  # Scheduled jobs are created, but not yet accepted by the transcoders.
  # This method uses pagination.
  def scheduled;    jobs_index(Job.scheduled); end
  # == Returns a list of accepted jobs
  # Accepted jobs are accepted by a \Transcoder, but have not yet begun transcoding.
  # This method uses pagination.
  def accepted;     jobs_index(Job.accepted); end
  # == Returns a list of jobs being processed.
  # Jobs being processed are being transcoded by a \Transcoder.
  # This method uses pagination.
  def processing;   jobs_index(Job.processing); end
  # == Returns a list of jobs that are on hold
  # Jobs will be put on hold when a \Transcoder instance is unavailable.
  # This method uses pagination.
  def on_hold;      jobs_index(Job.on_hold); end
  # == Returns a list of successfully completed jobs
  # These jobs have been successfully transcoded.
  # This method uses pagination.
  def success;      jobs_index(Job.success); end
  alias_method :completed, :success
  # == Returns a list of failed jobs
  # Jobs become failed if the \Transcoder reports an error.
  # This method uses pagination.
  def failed;       jobs_index(Job.failed); end
  
  # == Creates a job
  #
  # Creates a job using the specified parameters, which are all required. If the request was valid,
  # the created job is returned. If the request could not be completed, a list of errors will be returned.
  #
  # If the job is successfully created, two extra headers will be sent in the response.
  # The header <tt>X-State-Changes-Location</tt> contains the location of the state changes endpoint for this job.
  # The header <tt>X-Notifications-Location</tt> contains the location of the notifications endpoint for this job.
  #
  # === Parameters
  # <tt>input</tt>, <tt>output</tt> and <tt>preset</tt> are required parameters.
  # <tt>input</tt>:: Input file to process.
  # <tt>output</tt>:: Output file to write to.
  # <tt>preset</tt>:: Preset name to use.
  # <tt>notify</tt>:: A list of email addresses and urls separated by commas.
  # <tt>additional</tt>:: Additional parameters to override preset params.
  # <tt>priority</tt>:: Priority of a job, higher number equals higher priority.
  #
  # If a job enters the completed or failed state, a notification will be sent to the emails and urls specified in the 
  # <tt>notify</tt> parameter. Urls will receive a POST request with the JSON representation of the job as body.
  #
  # === Response codes
  # <tt>success</tt>:: <tt>201 created</tt>
  # <tt>failed</tt>::  <tt>406 Unprocessable Entity</tt>
  #
  # === Example
  #   $ curl -d 'input=/tmp/foo.flv&output=/tmp/bar.mp4&preset=h264' http://localhost:3000/api/jobs
  #
  #   {
  #     "job": {
  #       "additional_parameters":"",
  #       "callback_url":"http://localhost:3000/api/jobs/26",
  #       "completed_at":null,
  #       "created_at":"2011-05-10T08:25:00Z",
  #       "destination_file":"/tmp/bar.mp4",
  #       "duration":null,
  #       "filesize":null,
  #       "host_id":1,
  #       "id":26,
  #       "message":null,
  #       "preset_id":1,
  #       "priority":0,
  #       "progress":null,
  #       "remote_job_id":"fa832776a64b6844fb9f1a244757734a9d83c00f",
  #       "source_file":"/tmp/foo.flv",
  #       "state":"accepted",
  #       "transcoding_started_at":"2011-05-10T08:25:03Z",
  #       "updated_at":"2011-05-10T08:25:03Z" 
  #     }
  #   }  
  def create
    job = Job.from_api(params, :callback_url => lambda { |job| api_job_url(job) })
    if job.valid?
      response.headers["X-State-Changes-Location"] = api_state_changes_url(job)
      response.headers["X-Notifications-Location"] = api_notifications_url(job)
      respond_with job, :location => api_job_url(job) do |format|
        format.html { redirect_to jobs_path }
      end
    else
      respond_with job do |format|
        format.html { @job = job; render "/jobs/new"}
      end
    end
  end
  
  # == Updates a job with attributes from the transcoder
  #
  # This endpoint is specifically for updating a job from the transcoder and should not be called manually.
  def update #:nodoc:
    job = Job.find(params[:id])
    job.enter(params[:status], params)
    respond_with job, :location => api_job_url(job)
  end
  
  # == Shows a job
  #
  # The displayed job will have its status updated to provide an up-to-date view of attributes.
  #
  # === Parameters
  # <tt>id</tt>:: The id of the job to show
  #
  # === Example
  #   {
  #     "job": {
  #       "callback_url":"http://localhost:3000/api/jobs/26",
  #       "completed_at":null,
  #       "created_at":"2011-05-10T08:25:00Z",
  #       "destination_file":"/tmp/bar.mp4",
  #       "duration":null,
  #       "filesize":null,
  #       "host_id":1,
  #       "id":26,
  #       "message":null,
  #       "preset_id":1,
  #       "progress":null,
  #       "remote_job_id":"fa832776a64b6844fb9f1a244757734a9d83c00f",
  #       "source_file":"/tmp/foo.flv",
  #       "state":"accepted",
  #       "transcoding_started_at":"2011-05-10T08:25:03Z",
  #       "updated_at":"2011-05-10T08:25:03Z" 
  #     }
  #   }
  def show
    job = Job.find(params[:id])
    respond_with job
  end

  # == Purges failed jobs
  #
  # This method will permanently delete all failed jobs from the database.
  #
  #   $ curl -XDELETE http://localhost:3000/api/jobs/purge
  #   {} # HTTP Status: 200 OK
  def purge
    Job.failed.destroy_all
    render :nothing => true
  end

  # == Retries a job
  #
  # This method will force a job into the Scheduled state, regardless of which state it's currently in.
  #
  # === Parameters
  # <tt>id</tt>:: The id of the job to retry
  def retry
    job = Job.find(params[:id])
    job.enter(Job::Scheduled)
    respond_with job do |format|
      format.html { redirect_to jobs_path }
    end
  end
    
  private #:nodoc:
    def jobs_index(jobs)
      @jobs = jobs.order("created_at DESC").page(params[:page])
      respond_with @jobs
    end
end
