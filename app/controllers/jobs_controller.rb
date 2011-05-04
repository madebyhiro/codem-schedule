class JobsController < ApplicationController
  def index
    @history = History.new(params[:period])
    @jobs    = Job.recent
  end
end
