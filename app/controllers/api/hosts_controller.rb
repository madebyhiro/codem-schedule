class Api::HostsController < Api::ApiController
  def index
    hosts = Host.all
    hosts.map(&:update_status)
    respond_with hosts
  end
  
  def create
    host = Host.from_api(params)

    if host.valid?
      respond_with host, :location => api_host_url(host) do |format|
        format.html { redirect_to hosts_path }
      end
    else
      respond_with host do |format|
        format.html { @host = host; render "/hosts/new"}
      end
    end
  end
  
  def show
    host = Host.find(params[:id])
    host.update_status
    respond_with host
  end
end
