class Host < ActiveRecord::Base
  def status
    available ? 'Available' : 'Not available'
  end
  
  def update_status
    self.status_checked_at    = Time.zone.now
    self.available            = false

    begin
      response = RestClient.get("#{url}/jobs")
      self.total_slots          = response['max_slots']
      self.available_slots      = response['free_slots']
      self.available            = true
    rescue Errno::ECONNREFUSED, SocketError, Errno::ENETUNREACH
    end

    save
  end
end
