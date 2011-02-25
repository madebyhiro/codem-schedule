class Host < ActiveRecord::Base
  include HTTParty
  format :json
  
  has_many :jobs

  before_validation :fix_address
  validates_presence_of :address

  before_save :update_status
  
  def self.with_available_slots
    all.select { |h| h.available }
  end
  
  def status
    available ? 'Available' : 'Not available'
  end
  
  def used_slots
    total_slots - available_slots
  end

  def update_status
    begin
      response = Host.get("#{address}/jobs")
    rescue Errno::ECONNREFUSED
    end
    if response
      self.total_slots          = response['max_slots']
      self.available_slots      = response['free_slots']
      self.status_checked_at    = Time.zone.now
      self.available            = true
    end
  end
  
  private
    def fix_address
      unless address.blank?
        self.address = "http://#{address}" unless self.address =~ /^http:\/\//
        self.address.gsub!(/\/$/, '')
      end
    end
end
