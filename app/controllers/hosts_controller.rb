class HostsController < ApplicationController
  def index
    @hosts = Host.all
    @hosts.map(&:update_status)
  end

  def new
    @host = Host.new
  end

  def edit
    @host = Host.find(params[:id])
  end
end
