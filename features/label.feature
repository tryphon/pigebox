Feature: Manage labels
  In order to find later time marks
  An user
  wants to manage labels with PibeBox

  Scenario: Create a label with pige interface
    Given I am on /sources/1/labels/new
    And I fill in "Name" with "Label 1"
    When I press "Create"
    And I should see "Label 1"
