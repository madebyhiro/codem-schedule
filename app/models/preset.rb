class Preset < ActiveRecord::Base
  has_many :jobs
  has_many :notifications, :dependent => :destroy
    
  accepts_nested_attributes_for :notifications, :reject_if => Proc.new { |attrs| attrs['value'].blank? }
  
  validates :name, :presence => true, :uniqueness => true
end
