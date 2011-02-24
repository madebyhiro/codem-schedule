class DashboardController < ApplicationController
  def index
    @jobs = Job.recent
  end
end
