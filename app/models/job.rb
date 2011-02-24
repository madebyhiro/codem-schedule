class Job < ActiveRecord::Base
  include Codem::Base
  
  belongs_to :host
  belongs_to :preset

  validates_presence_of :source_file, :destination_file, :allow_blank => false
  validates_presence_of :preset_id
    
  scope :recent, :order => "updated_at DESC", :limit => 10, :include => :host
end
