# = Scheduler Controller
#
# This controller manages the flow of jobs by updating the status for noteable jobs.
# A good practice would be to call this endpoint from something like <tt>cron</tt>
# every 2 minutes or the like.
class Api::SchedulerController < Api::ApiController
  # == Update the statuses for all relevant jobs
  #
  # All unfinished jobs will have their statuses updated, and the number of affected jobs will be returned as result.
  # A job is unfinished if it's state is either <tt>scheduled</tt>, <tt>accepted</tt>, <tt>processing</tt> or <tt>on hold</tt>.
  def schedule
    respond_with Schedule.run!
  end
end
