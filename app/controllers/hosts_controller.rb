class HostsController < ApplicationController
  def index
    @hosts = Host.all
  end
  
  def new
  end
end
