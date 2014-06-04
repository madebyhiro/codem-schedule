class JobsController < ApplicationController
  def index
    @history = History.new(params[:period])
    @jobs    = Job.recents(page: params[:page], sort: sort_column, dir: sort_direction, query: params[:q])
  end
  
  def show
    @job = Job.find(params[:id])
  end
  
  def new
    @job = Job.new
  end
end
