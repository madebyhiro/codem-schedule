class DashboardController < ApplicationController
  def index
    @jobs = Job.recent
    @history = History.new(params[:period])
  end
end
