class HostsController < ApplicationController
  def index
    @hosts = Host.all
  end
  
  def new
    @host = Host.new
  end
  
  def create
    @host = Host.new(params[:host])
    if @host.save
      redirect_to hosts_path, :notice => "Host has been save"
    else
      render :action => "new"
    end
  end
  
  def status
    if @host = Host.find_by_id(params[:id])
      @host.update_status
      render :partial => "status", :locals => {:host => @host}
    end
  end
end
