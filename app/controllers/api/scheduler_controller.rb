class Api::SchedulerController < Api::ApiController
  def schedule
    Runner.schedule!
    render :nothing => true
  end
end
