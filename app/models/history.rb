class History
  include ActiveRecord::Serialization
  include ActionView::Helpers::NumberHelper

  attr_accessor :period

  def initialize(period = nil)
    period = 'today' if period.nil?
    @period = period
  end

  def jobs
    @jobs ||= Job.where(created_at: between)
  end

  def between
    case period
    when 'today'
      Time.current.at_beginning_of_day..Time.current
    when 'yesterday'
      (Time.current.at_beginning_of_day - 1.day)..Time.current.at_beginning_of_day
    when 'week'
      7.days.ago.at_beginning_of_day..Time.current
    when 'month'
      30.days.ago.at_beginning_of_day..Time.current
    when 'all'
      Time.new(1970, 1, 1)..Time.current
    end
  end

  def completed_jobs
    @success ||= jobs.where(state: Job::Success)
  end

  def number_of_completed_jobs
    completed_jobs.size
  end

  def failed_jobs
    @failed ||= Job.where(created_at: between).where(state: Job::Failed)
  end

  def number_of_failed_jobs
    failed_jobs.size
  end

  def processing_jobs
    @transcoding ||= jobs.where(state: Job::Processing)
  end

  def number_of_processing_jobs
    processing_jobs.size
  end

  def seconds_encoded
    completed_jobs.reduce(0) { |a, e| a + e.duration.to_i }
  end

  def average_processing_time
    return 0 unless completed_jobs.any?

    total_time = completed_jobs.reduce(0) do |a, e|
      a + (e.completed_at - e.transcoding_started_at)
    end

    total_time / completed_jobs.size
  end

  def average_queue_time
    return 0 unless completed_jobs.any?

    total_time = completed_jobs.reduce(0) do |a, e|
      a + (e.transcoding_started_at - e.created_at)
    end

    num = total_time / completed_jobs.size
    num < 1 ? 1 : num
  end

  def serializable_hash(_opts = {})
    super({
      methods: [:seconds_encoded, :average_processing_time, :average_queue_time,
                :number_of_completed_jobs, :number_of_failed_jobs, :number_of_processing_jobs]
    })
  end

  def to_json(opts = {})
    serializable_hash.to_json(opts)
  end

  def to_xml(opts = {})
    serializable_hash(opts).to_xml(root: 'statistics')
  end

  private

  def self.inheritance_column
    nil
  end
  def attributes
    {}
  end
end
