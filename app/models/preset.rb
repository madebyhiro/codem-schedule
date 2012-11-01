class Preset < ActiveRecord::Base
  has_many :jobs
  
  validates :name, :parameters, :presence => true
  validates :name, :uniqueness => true
  
  def self.from_api(attributes)
    attributes = attributes[:preset] if attributes[:preset]
    create(:name => attributes['name'], 
           :parameters => attributes['parameters'],
           :weight => attributes['weight'])
  end
end
