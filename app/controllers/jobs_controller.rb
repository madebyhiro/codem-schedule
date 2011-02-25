class JobsController < ApplicationController
  def index
    @history = History.new(params[:period])
    @jobs = Job.paginate(:include => [:host, :preset], :order => "created_at", :page => params[:page], :per_page => 20)
  end
  
  def new
    @job = Job.new
  end
  
  def create
    @job = Job.new(params[:job])
    if @job.save
      flash[:notice] = "Job has been created"
      redirect_to jobs_path
    else
      flash[:error] = "Job could not be saved"
      render :action => "new"
    end
  end
end
