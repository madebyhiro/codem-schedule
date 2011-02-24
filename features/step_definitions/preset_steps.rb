Given /^a preset named "([^"]*)" with parameters "([^"]*)" exist$/ do |name, params|
  Preset.create!(:name => name, :parameters => params)
end
