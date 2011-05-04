class Job < ActiveRecord::Base
  Scheduled   = 'scheduled'
  Transcoding = 'transcoding'
  OnHold      = 'on_hold'
  Completed   = 'complete'
  Failed      = 'failed'
  
  after_initialize :set_initial_state  

  belongs_to :preset
  
  scope :recent, :order => "updated_at DESC", :limit => 10, :include => [:host, :preset]
  
  def self.from_api(options)
    new(:source_file => options['input'],
        :destination_file => options['output'],
        :preset => Preset.find_by_name(options['preset']))
  end
  
  private
    def set_initial_state
      self.state ||= Scheduled
    end
end
