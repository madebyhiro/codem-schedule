# = State Changes Controller
#
# Whenever a job enteres a state for the first time, a state change will be generated and stored in the database.
# This allowes to get an overview of the progress of the job, from <tt>scheduled</tt> to <tt>completed</tt>.
module Api
  class StateChangesController < ApiController
    before_action :find_job

    # == Lists state changes for the specified job
    #
    # A state changes gets created the first time a job enters this state. Along with the actual state and the timestamp of it
    # happening, the message from the Transcoder instance will be stored if present.
    #
    # === Parameters
    # <tt>id</tt>::   The id of the job
    #
    # === Example
    # The normal flow would be: <tt>scheduled</tt>, <tt>processing</tt>, <tt>success</tt>:
    #   [
    #     {
    #       state_change: {
    #         job_id: 25
    #         id: 73
    #         created_at: "2011-05-09T13:53:31Z"
    #         message: "The transcoder accepted your job."
    #         updated_at: "2011-05-09T13:53:31Z"
    #         state: "scheduled"
    #       }
    #     },
    #     {
    #       state_change: {
    #         job_id: 25
    #         id: 74
    #         created_at: "2011-05-09T13:53:41Z"
    #         message: null
    #         updated_at: "2011-05-09T13:53:41Z"
    #         state: "processing"
    #       }
    #     },
    #     {
    #       state_change: {
    #         job_id: 25
    #         id: 75
    #         created_at: "2011-05-09T13:58:18Z"
    #         message: "ffmpeg finished succesfully."
    #         updated_at: "2011-05-09T13:58:18Z"
    #         state: "success"
    #       }
    #     }
    #   ]
    def index
      respond_with @job.state_changes
    end

    private #:nodoc:

    def find_job
      @job = Job.find(params[:id])
    end
  end
end
