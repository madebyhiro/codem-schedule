Feature: Creating a preset

  Background: 
    Given I am on the homepage
    
  Scenario: Creating a preset
    When  I follow "Presets"
    And   I follow "Add a new preset"
    And   I fill in "Name" with "x264"
    And   I fill in "Parameters" with "parameters"
    And   I press "Create Preset"
    Then  I should see "Preset has been created"
    And   I should see "x264"