class Job < ActiveRecord::Base
  include Codem::Base
  
  belongs_to :host
  belongs_to :preset
  has_many :state_changes, :order => 'created_at', :dependent => :destroy

  validates_presence_of :source_file, :destination_file, :allow_blank => false
  validates_presence_of :preset_id
    
  scope :recent, :order => "updated_at DESC", :limit => 10, :include => [:host, :preset]
  scope :scheduled, lambda { where(:state => 'scheduled') }
  scope :completed, lambda { where(:state => 'complete') }
  scope :failed, lambda { where(:state => 'failed') }
  
  def self.list(opts={})
    paginate(:include => [:host, :preset], 
             :order => "created_at", 
             :page => opts[:page], :per_page => opts[:per_page] || 20)
  end
end
