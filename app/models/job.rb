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
  
  has_many :state_changes, :order => 'created_at ASC', :dependent => :destroy
  has_many :notifications, :dependent => :destroy

  serialize :arguments

  scope :scheduled,   :conditions => { :state => Scheduled }
  scope :accepted,    :conditions => { :state => Accepted }
  scope :processing,  :conditions => { :state => Processing }
  scope :success,     :conditions => { :state => Success }
  scope :on_hold,     :conditions => { :state => OnHold }
  scope :failed,      :conditions => { :state => Failed }

  scope :unlocked,    :conditions => { :locked => false }

  scope :recent,      :include => [:host, :preset]
  
  scope :unfinished,  lambda { where("state in (?)", [Accepted, Processing, OnHold]) }
  scope :need_update, lambda { where("state in (?)", [Accepted, Processing, OnHold]) }
  
  validates :source_file, :destination_file, :preset_id, :presence => true
  
  class << self
    def from_api(options, opts)
      options = options[:job] if options[:job]

      args = {}
      options['arguments'].split(',').each do |arg|
        k,v = arg.split('=')
        args.merge!(k.to_sym => v)
      end if options['arguments']

      job = new(:source_file => options['input'],
                :destination_file => options['output'],
                :preset => Preset.find_by_name(options['preset']),
                :notifications => Notification.from_api(options[:notify]),
                :arguments => args)

      if job.save
        job.update_attributes :callback_url => opts[:callback_url].call(job)
        job.enter(Job::Scheduled)
      end

      job
    end

    def recents(opts={})
      jobs = scoped

      if opts[:query]
        jobs = Job.search(opts[:query])
      end

      jobs = jobs.recent.page(opts[:page])

      if opts[:sort] && opts[:dir]
        jobs = jobs.order('jobs.' + opts[:sort] + ' ' + opts[:dir])
      end

      jobs
    end

    def search(query)
      JobSearch.search(scoped, query)
    end
  end

  def needs_update?
    state == Accepted || state == Processing || state == OnHold
  end

  def finished?
    state == Success || state == Failed
  end
  
  def unfinished?
    state == Scheduled || state == Accepted || state == Processing || state == OnHold
  end

  def lock!(&block)
    raise "This job is already locked" if locked?

    if block_given?
      Job.transaction do
        begin
          update_attributes :locked => true
          yield
        ensure
          unlock!
        end
      end
    else
      update_attributes :locked => true
    end
  end

  def unlock!
    update_attributes :locked => false
  end
end
