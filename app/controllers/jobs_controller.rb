class JobsController < ApplicationController
  def index
    @history = History.new(params[:period])
    @jobs    = Job.recents(params[:page]).order(sort_column + " " + sort_direction)
    @jobs.collect { |j| Schedule.update_progress(j) }
  end
  
  def show
    @job = Job.find(params[:id], :include => [:host, :preset, [:state_changes => [:deliveries => :notification]]])
  end
  
  def new
  end
end
