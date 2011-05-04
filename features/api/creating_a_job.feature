@api
Feature: Creating a job via the API

  Background:
    Given a preset named "h264" exists
    
  Scenario: As JSON
    When I post the following to "/api/jobs" as JSON:
      """
      {"input":"foo.mpg", "output":"foo.mp4", "preset":"h264"}
      """
    Then a job should have been created with the following attributes:
      | source_file      | foo.mpg |
      | destination_file | foo.mp4 |
      | preset_name      | h264    |