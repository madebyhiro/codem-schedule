When /^I post the following to "([^"]*)" as JSON:$/ do |url, query|
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  post url, query
end
