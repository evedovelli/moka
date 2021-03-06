Feature: New battle
  To allow users to vote between options to get out of the house
  An user should be able to access the new battle form

Background:
    Given I am logged in

    Scenario: Admin cannot see battle form unless he press the button to add battle
      When I go to the home page
      Then I should not see the new battle form
      And I should see the button to add new battle

    @javascript
    Scenario: Admin can create a battle from home page
      When I go to the home page
      And I press the button to add new battle
      Then I should be on the home page
      And I should see the new battle form
      And I should not see the button to add new battle

    @javascript
    Scenario: Cancelling new battle creation
      When I go to the home page
      And I press the button to add new battle
      And I wait 1 second
      And I cancel battle creation
      Then I should be on the home page
      And I should not see the new battle form
      And I should see the button to add new battle

