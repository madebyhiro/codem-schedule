Given /^a host with address "([^"]*)" exists$/ do |address|
  Host.create!(:address => address)
end
