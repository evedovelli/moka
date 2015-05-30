Feature: New stuff
  To create stuffs whose participate of contests
  where users can elect which stuff should go home
  An admin should be able to access the new stuff form

Background:
    Given I am logged in
    And I am an admin

    @javascript
    Scenario: Admin cannot see stuff form unless he press the button to add stuff
      When I go to the stuff index page
      Then I should not see the new stuff form

    @javascript
    Scenario: Admin can create a stuff from stuff index page
      When I go to the stuff index page
      And I press the button to add new stuff
      Then I should be on the stuff index page
      And I should see the new stuff form

    @javascript
    Scenario: Cancelling new stuff creation
      When I go to the stuff index page
      And I press the button to add new stuff
      And I follow "Cancel"
      Then I should be on the stuff index page
      And I should not see the new stuff form

