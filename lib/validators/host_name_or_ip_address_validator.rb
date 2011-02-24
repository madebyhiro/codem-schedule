class HostNameOrIpAddressValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    puts value.inspect
  end
end