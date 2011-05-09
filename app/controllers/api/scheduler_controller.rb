class Api::SchedulerController < Api::ApiController
  def schedule
    respond_with Runner.schedule!
  end
end
