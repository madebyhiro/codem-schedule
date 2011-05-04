class Host < ActiveRecord::Base
  has_many :jobs
  
  def self.with_available_slots
    all.map(&:update_status)
    all.select { |h| h.available_slots > 0 }.shuffle
  end
  
  def update_status
    self.available = false

    begin
      response = RestClient.get("#{url}/jobs")
      
      if response.code == 200
        attrs = JSON::parse(response)
        self.total_slots          = attrs['max_slots']
        self.available_slots      = attrs['free_slots']
        self.available            = true
      end
      
    rescue Errno::ECONNREFUSED
    end

    save
  end
end
