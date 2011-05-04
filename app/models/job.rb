class Job < ActiveRecord::Base
  belongs_to :preset
  
  def self.from_api(options)
    new(:source_file => options['input'],
        :destination_file => options['output'],
        :preset => Preset.find_by_name(options['preset']))
  end
end
