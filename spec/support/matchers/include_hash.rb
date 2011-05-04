RSpec::Matchers.define :include_hash do |expected|
  match do |actual|
    actual.present? && actual.slice(*expected.keys) == expected
  end
end
