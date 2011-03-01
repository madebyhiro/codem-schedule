Given /^there is a preset named "([^"]*)"$/ do |name|
  Preset.create!(:name => name)
end