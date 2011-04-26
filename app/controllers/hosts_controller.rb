class HostsController < ApplicationController
  respond_to :xml, :json, :html
  respond_to :js, :only => [:status]
  
  def index
    @hosts = Host.all
    respond_with @hosts
  end
  
  def new
    @host = Host.new
    respond_with @host
  end
  
  def create
    @host = Host.new(params[:host])
    if @host.save
      flash[:notice] = "Host has been added"
    else
      flash[:error] = "Host could not be saved"
    end
    respond_with @host, :location => hosts_path
  end
  
  def edit
    @host = Host.find(params[:id])
    respond_with @host
  end
  
  def update
    @host = Host.find(params[:id])
    if @host.update_attributes(params[:host])
      flash[:notice] = "Host has been saved"
    else
      flash[:error] = "Host could not be saved"
    end
    respond_with @host, :location => hosts_path
  end
  
  def destroy
    host = Host.find(params[:id])
    host.destroy
    flash[:notice] = "Host has been deleted"
    respond_with host
  end
  
  def status
    @host = Host.find(params[:id])
    @host.update_status
    render :partial => "status", :locals => {:host => @host}
  end
end
