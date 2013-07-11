class Preset < ActiveRecord::Base
  has_many :jobs
  
  validates :name, :parameters, :presence => true
  validates :name, :uniqueness => true

  validate :thumbnail_options, :valid_json_options, :if => Proc.new { |p| p.thumbnail_options.present? }
  
  def self.from_api(attributes)
    attributes = attributes[:preset] if attributes[:preset]
    create(:name => attributes['name'], 
           :parameters => attributes['parameters'],
           :thumbnail_options => attributes['thumbnail_options'])
  end

  private
    def valid_json_options
      begin
        JSON.parse(self.thumbnail_options)
        true
      rescue JSON::ParserError
        errors.add(:thumbnail_options, "must be valid JSON")
        false
      end
    end
end
