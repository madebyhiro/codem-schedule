class Preset < ActiveRecord::Base
  has_many :jobs
  has_many :notifications, :as => :origin
  
  validates :name, :parameters, :presence => true
  validates :name, :uniqueness => true
  
  def self.from_api(attributes)
    new(:name => attributes['name'], 
        :parameters => attributes['parameters'],
        :notifications => Notification.from_api(attributes['notify']))
  end
end
