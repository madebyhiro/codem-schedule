Feature: Creating a host

  Background:
    Given I am on the homepage
    
  Scenario: Creating a host
    When  I follow "Hosts"
    And   I follow "Add a host"
    And   I fill in "Address" with "127.0.0.1"
    And   I press "Create Host"
    Then  I should see "Host has been added"
    And   I should see "127.0.0.1"
    