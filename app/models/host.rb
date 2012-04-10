class Host < ActiveRecord::Base
  has_many :jobs

  validates :name, :url, :presence => true

  before_save :normalize_url

  def self.from_api(opts)
    opts = opts[:host] if opts[:host] # Rails' forms wraps hashes in a root tag
    host = new(:name => opts['name'], :url => opts['url'])
    if host.save
      host.update_status
    end
    host
  end
  
  def self.with_available_slots
    @@with_available_slots ||= all.map(&:update_status).select { |h| h.available_slots > 0 }.shuffle
  end
  
  def update_status
    return self if status_updated_at && status_updated_at > 10.seconds.ago
    
    self.available = false
    self.status_updated_at = Time.current
      
    if attrs = Transcoder.host_status(self)
      self.total_slots          = attrs['max_slots']
      self.available_slots      = attrs['free_slots']
      self.available            = true
    end
    
    save
    
    self
  end

  private
    def normalize_url
      self.url = self.url.to_s.gsub(/\/$/, '')
    end
end

