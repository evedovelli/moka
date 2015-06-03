Feature: New option
  To create options whose participate of battles
  where users can elect which option should go home
  An admin should be able to access the new option form

Background:
    Given I am logged in
    And I am an admin

    @javascript
    Scenario: Admin cannot see option form unless he press the button to add option
      When I go to the option index page
      Then I should not see the new option form

    @javascript
    Scenario: Admin can create a option from option index page
      When I go to the option index page
      And I press the button to add new option
      Then I should be on the option index page
      And I should see the new option form

    @javascript
    Scenario: Cancelling new option creation
      When I go to the option index page
      And I press the button to add new option
      And I follow "Cancel"
      Then I should be on the option index page
      And I should not see the new option form

