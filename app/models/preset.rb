class Preset < ActiveRecord::Base
  has_many :jobs

  validates :name, presence: true, uniqueness: true

  validate :should_have_params_or_thumbnail_options
  validate :thumbnail_options, :valid_json_options, if: proc { |p| p.thumbnail_options.present? }

  def self.from_api(attributes)
    attributes = attributes[:preset] if attributes[:preset]
    create(name: attributes['name'],
           parameters: attributes['parameters'],
           thumbnail_options: attributes['thumbnail_options'])
  end

  private

  def valid_json_options
    MultiJson.load(thumbnail_options)
    true
  rescue MultiJson::ParseError
    errors.add(:thumbnail_options, 'must be valid JSON')
    false
  end

  def should_have_params_or_thumbnail_options
    return true if parameters.present? || thumbnail_options.present?
    errors.add(:base, 'Either parameters or thumbnail options should be specified')
  end
end
