class Api::StateChangesController < Api::ApiController
  before_filter :find_job
  
  def index
    respond_with @job.state_changes.page(params[:page]).per(20)
  end
  
  private
    def find_job
      @job = Job.find(params[:id], :include => :state_changes)
    end
end
