class Host < ActiveRecord::Base
  include HTTParty
  format :json
  
  has_many :jobs

  before_validation :fix_address
  validates_presence_of :address

  after_create :update_status
  
  def self.with_available_slots
    all.map(&:update_status)
    all.select { |h| h.available_slots > 0 }.shuffle
  end
  
  def status
    available ? 'Available' : 'Not available'
  end
  
  def used_slots
    total_slots - available_slots
  end

  def update_status
    self.status_checked_at    = Time.zone.now
    self.available            = false

    begin
      response = Host.get("#{address}/jobs")
      self.total_slots          = response['max_slots']
      self.available_slots      = response['free_slots']
      self.available            = true
    rescue Errno::ECONNREFUSED, SocketError
    end

    save
  end
  
  private
    def fix_address
      unless address.blank?
        self.address = "http://#{address}" unless self.address =~ /^http:\/\//
        self.address.gsub!(/\/$/, '')
      end
    end
end
