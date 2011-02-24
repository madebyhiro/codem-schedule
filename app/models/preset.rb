class Preset < ActiveRecord::Base
  has_many :jobs
  
  validates :name, :presence => true, :uniqueness => true
end
