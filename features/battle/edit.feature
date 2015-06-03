Feature: Edit battle
  If an battle was created with a mistake
  An admin should be able to access the edit battle form

Background:
    Given I am logged in
    And I am an admin
    And the following battles were added:
    | starts_at                 | finishes_at               |
    | 2015-05-01 10:30:14 -0300 | 2015-05-14 10:30:15 -0300 |
    | 2015-05-22 10:30:14 -0300 | 2015-05-25 10:30:15 -0300 |
    | 2015-05-26 10:30:14 -0300 | 2015-05-29 10:30:15 -0300 |

    Scenario: Admin cannot see battle form unless he press the button to edit battle
      When I go to the battle index page
      Then I should not see the edit battle form for 1st battle

    @javascript
    Scenario: Admin can edit an battle from battle index page
      When I go to the battle index page
      And I press the button to edit 1st battle
      Then I should be on the battle index page
      And I should see the edit form for the 1st battle
      And I should see 2 battles

    @javascript
    Scenario: Cancelling new battle creation
      When I go to the battle index page
      And I press the button to edit 1st battle
      And I follow "Cancel"
      Then I should be on the battle index page
      And I should not see the edit battle form for 1st battle
      And I should see 3 battles


