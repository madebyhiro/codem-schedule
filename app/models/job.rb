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
  has_many :notifications, :dependent => :destroy

  scope :scheduled,   :conditions => { :state => Scheduled }, :order => ["created_at DESC"]
  scope :accepted,    :conditions => { :state => Accepted }, :order => ["created_at DESC"]
  scope :processing,  :conditions => { :state => Processing }, :order => ["created_at DESC"]
  scope :success,     :conditions => { :state => Success }, :order => ["created_at DESC"]
  scope :on_hold,     :conditions => { :state => OnHold }, :order => ["created_at DESC"]
  scope :failed,      :conditions => { :state => Failed }, :order => ["created_at DESC"]

  scope :recent, :include => [:host, :preset], :order => ["created_at DESC"]
  
  scope :unfinished, lambda { where("state in (?)", [Scheduled, Accepted, Processing, OnHold]) }
  
  validates :source_file, :destination_file, :preset_id, :presence => true
  
  def self.from_api(options, opts)
    job = new(:source_file => options['input'],
              :destination_file => options['output'],
              :preset => Preset.find_by_name(options['preset']),
              :notifications => Notification.from_api(options[:notify]))

    if job.save
      job.update_attributes :callback_url => opts[:callback_url].call(job)
      job.enter(Job::Scheduled)
    end
    
    job
  end

  def self.recents(page=nil)
    recent.page(page).per(25)
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
