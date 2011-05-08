class Preset < ActiveRecord::Base
  has_many :jobs
  
  validates :name, :parameters, :presence => true
  validates :name, :uniqueness => true
  
  def self.from_api(attributes)
    new(:name => attributes['name'], 
        :parameters => attributes['parameters'])
  end
end
