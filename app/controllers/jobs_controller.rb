class JobsController < ApplicationController
  def index
    @jobs = Job.paginate(:include => [:host, :preset], :order => "created_at DESC", :page => params[:page])
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
