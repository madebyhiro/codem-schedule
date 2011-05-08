class Notification < ActiveRecord::Base
  belongs_to :job
  
  def self.from_api(options=nil)
    return [] if options.blank?

    options.split(',').collect do |value|
      value.include?('@') ? EmailNotification.new(:value => value) : UrlNotification.new(:value => value)
    end
  end
end
