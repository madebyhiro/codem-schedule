class StateChange < ActiveRecord::Base
  belongs_to :job
  has_many :deliveries

  acts_as_list scope: :job_id
end
