Feature: Manage labels
  In order to find later time marks
  An user
  wants to manage labels with PibeBox

  Scenario: Create a label with pige interface
    Given I am on /sources/1/labels/new
    And I fill in "Name" with "Label 1"
    When I press "Create"
    Then a label "Label 1" should exist

  Scenario: Create a label with UDP request
    When a label "Label 1" is created via UDP
    Then a label "Label 1" should exist

  @long
  Scenario: Label count should be limited
    Given a label "Old Label" is created
    When 5000 labels are created
    Then a label "Old Label" should not exist
