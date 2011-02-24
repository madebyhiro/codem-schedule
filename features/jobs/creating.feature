Feature: Creating a job

  Background:
    Given a host with address "localhost" exists
    And   a preset named "h264" with parameters "params" exist
    And   I am on the homepage
    
  Scenario: Creating a job
    When  I follow "Jobs"
    And   I follow "Add a job"
    And   I fill in "Source file" with "/e/ap/foo.mkv"
    And   I fill in "Destination file" with "/d/ap"
    And   I select "h264" from "Preset"
    And   I press "Create Job"
    Then  I should see "Job has been created"
    And   I should see "foo.mkv"