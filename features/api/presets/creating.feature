@api
Feature: Creating a preset using the API

  Scenario: Creating a preset via JSON
    Given I send and accept JSON
    When  I send a POST request to "/presets" with the following:
    """
      { "preset" : { "name" : "test" } }
    """
    Then  the response should be "201"

  Scenario: No name
    Given I send and accept JSON
    When  I send a POST request to "/presets" with the following:
    """
      { "preset" : {} }
    """
    Then  the response should be "422"
    And   I should see JSON:
    """
      { "name" : ["can't be blank" ] }
    """
