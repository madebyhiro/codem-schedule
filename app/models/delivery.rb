class Delivery < ActiveRecord::Base
  belongs_to :notification
  belongs_to :state_change
end
