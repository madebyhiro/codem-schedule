# = Notifications Controller
#
# Whenever a job enters the <tt>completed</tt> or <tt>failed</tt> state, 
# a notification can be sent to either an url or an email address.
# These can be specified using the <tt>notify</tt> parameters in Api::JobsController#create.
#
# A notification can be <tt>scheduled</tt>, <tt>completed</tt> or <tt>failed</tt>.
#
# If <tt>scheduled</tt>, the job is still processing, so the notification has not been sent yet.
# If <tt>completed</tt>, the notification has been sent successfully.
# If <tt>failed</tt>, either the url was unreachable or sending to the email address returned an error.
class Api::NotificationsController < Api::ApiController
  before_filter :find_job
  # == Returns a list of notifications for a job
  #
  # === Parameters
  # id:: Id of the job to show notifications for
  #
  # === Example
  #   $ curl http://localhost:3000/api/jobs/15/notifications.json
  #
  #   [
  #     {"email_notification":{
  #       "created_at":"2011-05-09T12:37:11Z",
  #       "id":4,
  #       "job_id":15,
  #       "notified_at":"2011-05-09T12:56:32Z",
  #       "state":"success",
  #       "updated_at":"2011-05-09T12:56:32Z",
  #       "value":"user@host.com"}
  #     },
  #     {"url_notification":{
  #       "created_at":"2011-05-09T12:37:11Z",
  #       "id":4,
  #       "job_id":15,
  #       "notified_at":"",
  #       "state":"failed",
  #       "updated_at":"2011-05-09T12:56:32Z",
  #       "value":"http://host.com"}
  #     }
  #   ]
  def index
    respond_with @job.notifications
  end
  
  private
    def find_job
      @job = Job.find(params[:id], :include => [:notifications])
    end
end
