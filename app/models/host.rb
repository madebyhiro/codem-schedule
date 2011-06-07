class Host < ActiveRecord::Base
  has_many :jobs

  validates :name, :url, :presence => true

  def self.from_api(opts)
    host = new(:name => opts['name'], :url => opts['url'])
    if host.save
      host.update_status
    end
    host
  end
  
  def self.with_available_slots
    all.map(&:update_status)
    all.select { |h| h.available_slots > 0 }.shuffle
  end
  
  def update_status
    return self if updated_at > 10.seconds.ago
    
    self.available = false
      
    if attrs = Transcoder.host_status(self)
      self.total_slots          = attrs['max_slots']
      self.available_slots      = attrs['free_slots']
      self.available            = true
    end
    
    save
    
    self
  end
end
