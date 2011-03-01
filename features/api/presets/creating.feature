@api
Feature: Creating a preset using the API

  Scenario: Creating a preset via JSON
    Given I send and accept JSON
    When  I send a POST request to "/presets" with the following:
    """
      { "preset" : { "name" : "test" } }
    """
    Then  the response should be "201"

  Scenario: Creating a preset via XML
    Given I send and accept XML
    When  I send a POST request to "/presets" with the following:
    """
      <preset><name>name</name></preset>
    """
    Then  the response should be "201"

  Scenario: No name via JSON
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

  Scenario: No name via XML
    Given I send and accept XML
    When  I send a POST request to "/presets" with the following:
    """
      <preset></preset>
    """
    Then  the response should be "422"
    And   I should see XML:
    """
    <?xml version="1.0" encoding="UTF-8"?>
    <errors>
      <error>Name can't be blank</error>
    </errors>
    
    """
