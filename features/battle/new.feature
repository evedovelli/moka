Feature: New battle
  To allow users to vote between options to get out of the house
  An admin should be able to access the new battle form

Background:
    Given I am logged in
    And I am an admin

    Scenario: Admin cannot see battle form unless he press the button to add battle
      When I go to the battle index page
      Then I should not see the new battle form

    @javascript
    Scenario: Admin can create an battle from battle index page
      When I go to the battle index page
      And I press the button to add new battle
      Then I should be on the battle index page
      And I should see the new battle form

    @javascript
    Scenario: Cancelling new battle creation
      When I go to the battle index page
      And I press the button to add new battle
      And I follow "Cancel"
      Then I should be on the battle index page
      And I should not see the new battle form
