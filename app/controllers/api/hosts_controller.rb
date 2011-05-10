# = Hosts controller
#
# A host represents an instance of a Transcoder, defined by name and url
class Api::HostsController < Api::ApiController
  # == Displays a list of hosts
  #
  # All returned hosts will ahve their statuses updated to provide an up-to-date view of their slots.
  #
  # === Example
  #   $ curl http://localhost:3000/api/hosts
  #
  #   [
  #      {"host":{
  #        "available":true,
  #        "available_slots":1,
  #        "created_at":"2011-05-09T11:59:52Z",
  #        "id":1,
  #        "name":"Localhost",
  #        "total_slots":1,
  #        "updated_at":"2011-05-09T13:53:31Z",
  #        "url":"http://127.0.0.1:8080"}
  #      }
  #    ]
  def index
    hosts = Host.all
    hosts.map(&:update_status)
    respond_with hosts
  end
  
  # == Creates a host
  # Creates a host using the specified parameters, all are required. If the request was valid,
  # the created host is returned. If the request could not be completed, a list of errors will be returned.
  #
  # === Parameters
  # <tt>name</tt>:: The name of the host
  # <tt>url</tt>::  The url of the host
  #
  # === Response codes
  # <tt>success</tt>:: <tt>201 created</tt>
  # <tt>failed</tt>::  <tt>406 Unprocessable Entity</tt>
  #
  # === Example 
  #   $ curl -d 'name=transcoder&url=http://transcoder.com' http://localhost:3000/api/hosts
  #
  #   {
  #     "host": {
  #       "available":true,
  #       "available_slots":10,
  #       "created_at":"2011-05-09T15:32:53Z",
  #       "id":6,
  #        "name":"transcoder",
  #        "total_slots":10,
  #        "updated_at":"2011-05-09T15:32:53Z",
  #        "url":"http://transcoder.com"
  #     }
  #   }
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
  
  # == Shows a specific host
  #
  # The host will have its status updated to provide an up-to-date view of the slots.
  # 
  # === Parameters
  # <tt>id</tt>:: The id of the host to show
  #
  # === Example
  #   $ curl http://localhost:3000/api/hosts/1
  #
  #   {
  #      "host":{
  #        "available":true,
  #        "available_slots":1,
  #        "created_at":"2011-05-09T11:59:52Z",
  #        "id":1,
  #        "name":"Localhost",
  #        "total_slots":1,
  #        "updated_at":"2011-05-09T13:53:31Z",
  #        "url":"http://127.0.0.1:8080"}
  #      }
  def show
    host = Host.find(params[:id])
    host.update_status
    respond_with host
  end
end
