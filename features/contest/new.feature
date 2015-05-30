Feature: New contest
  To allow users to vote between stuffs to get out of the house
  An admin should be able to access the new contest form

Background:
    Given I am logged in
    And I am an admin

    Scenario: Admin cannot see contest form unless he press the button to add contest
      When I go to the contest index page
      Then I should not see the new contest form

    @javascript
    Scenario: Admin can create an contest from contest index page
      When I go to the contest index page
      And I press the button to add new contest
      Then I should be on the contest index page
      And I should see the new contest form

    @javascript
    Scenario: Cancelling new contest creation
      When I go to the contest index page
      And I press the button to add new contest
      And I follow "Cancel"
      Then I should be on the contest index page
      And I should not see the new contest form

