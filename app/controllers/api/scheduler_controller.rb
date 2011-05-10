# = Scheduler Controller
#
# This controller manages the flow of jobs by updating the status for noteable jobs.
class Api::SchedulerController < Api::ApiController
  # == Update the statuses for all relevant jobs
  #
  # All unfinished jobs will have their statuses updated, and are returned in the response.
  # A job is unfinished if it's state is either scheduled, accepted, processing or on hold.
  def schedule
    respond_with Runner.schedule!
  end
end
