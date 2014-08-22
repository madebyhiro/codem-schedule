class JsonValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    JSON.parse(value)
  rescue JSON::ParserError
    record.errors[attribute] << (options[:message] || 'must be valid JSON')
  end
end
