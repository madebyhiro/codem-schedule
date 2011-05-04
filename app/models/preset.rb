class Preset < ActiveRecord::Base
  has_many :jobs
  
  validates :name, :parameters, :presence => true
  validates :name, :uniqueness => true
end
