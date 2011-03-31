class Job < ActiveRecord::Base
  include Codem::Base
  include HTTParty
  format :json
  
  belongs_to :host
  belongs_to :preset
  has_many :state_changes, :order => 'created_at', :dependent => :destroy

  validates_presence_of :source_file, :destination_file, :allow_blank => false
  validates_presence_of :preset_id
    
  scope :recent, :order => "updated_at DESC", :limit => 10, :include => [:host, :preset]
  scope :scheduled, lambda { where(:state => Codem::Scheduled) }
  scope :transcoding, lambda { where(:state => Codem::Transcoding) }
  scope :completed, lambda { where(:state => Codem::Completed) }
  scope :failed, lambda { where(:state => Codem::Failed) }

  def self.list(opts={})
    jobs = paginate(:include => [:host, :preset],
                    :order => "created_at DESC", 
                    :page => opts[:page], :per_page => opts[:per_page] || 20)
    jobs.map(&:update_status!)
    jobs
  end

  def output_file
    File.basename(destination_file || '')
  end
  
  def basepath
    File.join(Rails.root, 'public', 'movies')
  end
  
  def output_file=(file)
    self.destination_file = File.join(basepath, file)
  end
  
  def update_status!
    if host && remote_jobid && state == Codem::Transcoding
      status = self.class.get("#{host.address}/jobs/#{remote_jobid}")
      update_attributes :progress => map_progress(status['progress']), 
                        :duration => status['duration'], 
                        :filesize => status['filesize']
    end
  end
  
  private
    def map_progress(progress)
      progress = progress.to_f
      progress > 1 ? progress / 100.0 : progress
    end
end
