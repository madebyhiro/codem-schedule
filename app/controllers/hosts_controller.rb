class HostsController < ApplicationController
  def index
    @hosts = Host.all
  end
  
  def new
    @host = Host.new
  end
  
  def edit
    @host = Host.find(params[:id])
  end
end
