class Notification < ActiveRecord::Base
  belongs_to :origin, :polymorphic => true
  belongs_to :job

  after_initialize :set_initial_state
  
  def self.from_api(options=nil)
    return [] if options.blank?

    options.split(',').collect do |value|
      value.include?('@') ? EmailNotification.new(:value => value) : UrlNotification.new(:value => value)
    end
  end
  
  def notify!(*args)
    begin
      do_notify!(*args)
      state = Job::Success
    rescue => e
      state = Job::Failed
    end
    update_attributes :state => state, :notified_at => Time.current
    self
  end
  
  def name
    self.class.to_s.gsub('Notification', '')
  end
  
  def initial_state
    Job::Scheduled
  end
  
  def ==(other)
    self.value == other.value && self.type == other.type
  end
  
  private
    def set_initial_state
      self.state ||= Job::Scheduled
    end
end
