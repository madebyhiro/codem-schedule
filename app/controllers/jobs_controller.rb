class JobsController < ApplicationController
  helper_method :sort_column, :sort_direction
  
  def index
    @history = History.new(params[:period])
    @jobs    = Job.recents(params[:page]).order(sort_column + " " + sort_direction)
    @jobs.collect { |j| Schedule.update_progress(j) }
  end
  
  def show
    @job = Job.find(params[:id], :include => [:host, :preset, :state_changes, :notifications])
  end
  
  def new
  end
  
  private
    def sort_column
      params[:sort] || "created_at"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end
