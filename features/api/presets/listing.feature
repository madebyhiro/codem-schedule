@api
Feature: Listing presets

  Background:
    Given there is a preset named "preset"
    
  Scenario: Listing presets via JSON
    Given I send and accept JSON
    When  I send a GET request for "/presets"
    Then  the JSON response should be an array with 1 "preset" elements

  Scenario: Listing presets via XML
    Given I send and accept XML
    When  I send a GET request for "/presets"
    Then  the XML response should be a "presets" array with 1 "preset" elements
