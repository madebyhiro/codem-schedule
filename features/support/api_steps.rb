World(Rack::Test::Methods)

Given /^I send and accept XML$/ do
  header 'Accept', 'text/xml'
  header 'Content-Type', 'text/xml'
end

Given /^I send and accept JSON$/ do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
end

When /^I send a GET request for "([^\"]*)"$/ do |path|
  get path
end

When /^I send a POST request to "([^\"]*)" with the following:$/ do |path, body|
  post path, body
end

When /^I send a PUT request to "([^\"]*)" with the following:$/ do |path, body|
  put path, body
end

When /^I send a DELETE request to "([^\"]*)"$/ do |path|
  delete path
end

Then /^the response should be "([^\"]*)"$/ do |status|
  last_response.status.should == status.to_i
end

Then /^the XML response should be a "([^\"]*)" array with (\d+) "([^\"]*)" elements$/ do |tag, number_of_children, child_tag|
  page = Nokogiri::XML(last_response.body)
  page.xpath("//#{tag}/#{child_tag}").length.should == number_of_children.to_i
end

Then /^the JSON response should be an array with (\d+) "([^\"]*)" elements$/ do |number_of_children, name|
  page = JSON.parse(last_response.body)
  page.map { |d| d[name] }.length.should == number_of_children.to_i
end
