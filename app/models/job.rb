class Job < ActiveRecord::Base
  include Jobs::States

  Scheduled   = 'scheduled'
  Processing  = 'processing'
  OnHold      = 'on_hold'
  Success     = 'success'
  Failed      = 'failed'

  belongs_to :preset
  belongs_to :host

  has_many :state_changes, -> { order('position ASC') }, dependent: :destroy
  has_many :notifications, dependent: :destroy

  before_destroy :remove_job_from_transcoder

  serialize :arguments

  scope :scheduled,   -> { where(state: Scheduled) }
  scope :processing,  -> { where(state: Processing) }
  scope :success,     -> { where(state: Success) }
  scope :on_hold,     -> { where(state: OnHold) }
  scope :failed,      -> { where(state: Failed) }

  scope :recent,      -> { includes([:host, :preset]) }

  scope :unfinished,  -> { where('state in (?)', [Processing, OnHold]) }
  scope :need_update, -> { where('state in (?)', [Processing, OnHold]) }

  validates :source_file, :destination_file, :preset_id, presence: true

  class << self
    def from_api(options)
      options = options[:job] if options[:job]

      args = {}
      options['arguments'].split(',').each do |arg|
        k, v = arg.split('=')
        args.merge!(k.to_sym => v)
      end if options['arguments']

      job = new(source_file: options['input'],
                destination_file: options['output'],
                preset: Preset.find_by_name(options['preset']),
                priority: options['priority'],
                notifications: Notification.from_api(options[:notify]),
                arguments: args)

      job.enter(Job::Scheduled) if job.save

      job
    end

    def recents(opts = {})
      jobs = all

      jobs = Job.search(opts[:query]) if opts[:query]

      jobs = jobs.recent.page(opts[:page])

      if opts[:sort] && opts[:dir]
        jobs = jobs.order('jobs.' + opts[:sort] + ' ' + opts[:dir])
      end

      jobs
    end

    def search(query)
      JobSearch.search(all, query)
    end
  end

  def needs_update?
    state == Processing || state == OnHold
  end

  def finished?
    state == Success || state == Failed
  end

  def unfinished?
    state == Scheduled || state == Processing || state == OnHold
  end

  private

  def remove_job_from_transcoder
    Transcoder.remove_job(self)
    true
  end
end
