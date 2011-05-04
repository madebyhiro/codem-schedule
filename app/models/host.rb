class Host < ActiveRecord::Base
  has_many :jobs
  
  def self.with_available_slots
    all.map(&:update_status)
    all.select { |h| h.available_slots > 0 }.shuffle
  end
  
  def update_status
    self.available = false
      
    if attrs = Transcoder.status(self)
      self.total_slots          = attrs['max_slots']
      self.available_slots      = attrs['free_slots']
      self.available            = true
    end
    
    save
  end
end
