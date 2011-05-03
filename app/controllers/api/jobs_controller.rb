class Api::JobsController < ApplicationController
  respond_to :json, :xml
  verify :params => [:input, :output, :preset],
         :render => {:text => "`input', `output' and `preset' are required parameters"},
         :only => :create
  
  def create
    job = Job.from_api(params)
    job.save
    respond_with job
  end
end
