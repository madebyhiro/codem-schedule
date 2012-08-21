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

  serialize :arguments

  scope :scheduled,   :conditions => { :state => Scheduled }
  scope :accepted,    :conditions => { :state => Accepted }
  scope :processing,  :conditions => { :state => Processing }
  scope :success,     :conditions => { :state => Success }
  scope :on_hold,     :conditions => { :state => OnHold }
  scope :failed,      :conditions => { :state => Failed }

  scope :recent, :include => [:host, :preset]
  
  scope :unfinished,  lambda { where("state in (?)", [Accepted, Processing, OnHold]) }
  scope :need_update, lambda { where("state in (?)", [Accepted, Processing, OnHold]) }
  scope :search,      lambda { |q| includes(:host, :preset).where("jobs.id LIKE ? OR source_file LIKE ? OR presets.name LIKE ? OR hosts.name LIKE ? OR state LIKE ?", q, q, q, q, q) }
  
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
      jobs = recent.page(opts[:page])

      if opts[:sort] && opts[:dir]
        jobs = jobs.order(opts[:sort] + ' ' + opts[:dir])
      end

      if opts[:query]
        opts[:query].split(' ').each do |part|
          field,value = part.split(':')
          value = value.to_s

          case field
          when /^id|^job/
            jobs = jobs.where("jobs.id = ?", value)
          when /^state/
            jobs = jobs.where("state = ?", value)
          when /^source|^input/
            jobs = jobs.where("source_file LIKE ?", '%'+value+'%')
          when /^dest|^output/
            jobs = jobs.where("destination_file LIKE ?", '%'+value+'%')
          when /^file/
            value = '%'+value+'%'
            jobs = jobs.where("source_file LIKE ? OR destination_file LIKE ?", value, value)
          when /^preset/
            value = '%'+value+'%'
            jobs = jobs.includes(:preset).where("presets.name LIKE ?", value)
          when /^host/
            value = '%'+value+'%'
            jobs = jobs.includes(:host).where("hosts.name LIKE ?", value)
          when /^submitted/
            if dates = val_to_date(value)
              jobs = jobs.where("jobs.created_at BETWEEN ? AND ?", dates[0], dates[1])
            end
          when /^completed/
            if dates = val_to_date(value)
              jobs = jobs.where("jobs.completed_at BETWEEN ? AND ?", dates[0], dates[1])
            end
          when /^started/
            if dates = val_to_date(value)
              jobs = jobs.where("jobs.transcoding_started_at BETWEEN ? AND ?", dates[0], dates[1])
            end
          end
        end
      end

      jobs
    end

    private
    def val_to_date(val)
      val = val.gsub('%', '').gsub('_', ' ')
      if parsed = Chronic.parse(val)
        t0 = parsed.at_beginning_of_day
        t1 = t0 + 1.day
        [t0,t1]
      else
        false
      end
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
end
