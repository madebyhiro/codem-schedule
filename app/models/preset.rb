class Preset < ActiveRecord::Base
  has_many :jobs

  validates :name, presence: true, uniqueness: true
  validates :thumbnail_options, :segments_options, json: true, allow_blank: true

  validate :should_have_params_or_thumbnail_options
  validate :should_have_params_for_segments_options

  def self.from_api(attributes)
    attributes = attributes[:preset] if attributes[:preset]
    create(name: attributes['name'],
           parameters: attributes['parameters'],
           thumbnail_options: attributes['thumbnail_options'],
           segments_options: attributes['segments_options'])
  end

  private

  def should_have_params_or_thumbnail_options
    return true if parameters.present? || thumbnail_options.present?
    errors.add(:base, 'Either parameters or thumbnail options should be specified')
  end

  def should_have_params_for_segments_options
    if parameters.blank? && segments_options.present?
      errors.add(:base, 'Encoding parameters required for segmenting video')
    end
  end
end
