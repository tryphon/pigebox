Feature: Manage labels
  In order to find later time marks
  An user
  wants to manage labels with PibeBox
  
  Scenario: Create a label with pige interface
    Given I am on /sources/1/labels/new
    And I fill in "Nom" with "Label 1"
    When I press "Créer"
    Then I should see "Label créé(e) avec succès"
    And I should see "Label 1"
