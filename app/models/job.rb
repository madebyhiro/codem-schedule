class Job < ActiveRecord::Base
  include Jobs::States
  
  Scheduled   = 'scheduled'
  Accepted    = 'accepted'
  Processing  = 'processing'
  OnHold      = 'on_hold'
  Success     = 'success'
  Failed      = 'failed'
  
  belongs_to :preset
  belongs_to :host
  
  has_many :state_changes, :dependent => :destroy

  default_scope :order => ["created_at DESC"]
  scope :scheduled,   :conditions => { :state => Scheduled }
  scope :accepted,    :conditions => { :state => Accepted }
  scope :success,     :conditions => { :state => Success }
  scope :on_hold,     :conditions => { :state => OnHold }
  scope :failed,      :conditions => { :state => Failed }

  scope :recent, :limit => 25, :include => [:host, :preset]
  
  scope :unfinished, lambda { where("state in (?)", [Scheduled, Accepted, Processing, OnHold]).order("id ASC") }
  
  validates :source_file, :destination_file, :preset_id, :presence => true
  
  def self.from_api(options)
    new(:source_file => options['input'],
        :destination_file => options['output'],
        :preset => Preset.find_by_name(options['preset']))
  end

  # TODO actually update recent jobs
  def self.recents(page=nil)
    recent.page(page).per(20)
  end
  
  def update_status
    return self if finished?
    
    if state == Scheduled
      enter(Job::Scheduled)
    else
      if attrs = Transcoder.job_status(self)
        enter(attrs['status'], attrs)
      else
        enter(Job::OnHold)
      end
    end
    
    self
  end
  
  def finished?
    state == Success || state == Failed
  end
  
  def unfinished?
    state == Scheduled || state == Accepted || state == Processing || state == OnHold
  end
end
