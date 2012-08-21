class Notification < ActiveRecord::Base
  belongs_to :job
  has_many :deliveries, :dependent => :destroy, :order => "notified_at DESC"

  after_initialize :set_initial_state

  def self.from_api(options=nil)
    return [] if options.blank?

    options.split(',').collect do |value|
      value.strip!
      value.include?('@') ? 
        EmailNotification.new(:value => value) : 
        UrlNotification.new(:value => value)
    end
  end
  
  def notify!(*args)
    begin
      do_notify!(*args)
      update_attributes :state => Job::Success
    rescue => e
      update_attributes :state => Job::Failed
    end
    deliveries.create!(:state => state, :state_change => job.state_changes.last, :notified_at => Time.current)
    self
  end

  def name
    self.class.to_s.gsub('Notification', '')
  end
  
  def initial_state
    Job::Scheduled
  end
  
  private
    def set_initial_state
      self.state ||= Job::Scheduled
    end
end
