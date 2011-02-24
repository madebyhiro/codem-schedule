class HostsController < ApplicationController
  def index
    @hosts = Host.all
    @hosts.map(&:update_status)
  end
  
  def new
    @host = Host.new
  end
  
  def create
    @host = Host.new(params[:host])
    if @host.save
      flash[:notice] = "Host has been added"
      redirect_to hosts_path
    else
      flash[:error] = "Host could not be saved"
      render :action => "new"
    end
  end
end
