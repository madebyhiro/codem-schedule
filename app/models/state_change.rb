class StateChange < ActiveRecord::Base
  belongs_to :job
  has_many :deliveries
end
