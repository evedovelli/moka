Feature: Edit battle
  If a battle was created with a mistake
  An user should be able to access the edit battle form

Background:
    Given I am logged in
    And the following battles were added:
    | starts_at                 | duration  |
    | 2015-05-01 10:30:14 -0300 | 5000      |
    | 2015-05-22 10:30:14 -0300 | 3000      |
    | 2015-05-26 10:30:14 -0300 | 3000      |

    @javascript
    Scenario: Admin cannot see battle form unless he press the button to edit battle
      When I go to the home page
      Then I should not see the edit battle form for 1st battle

    @javascript
    Scenario: Admin can edit a battle from home page
      When I go to the home page
      And I press the button to edit 1st battle
      Then I should be on the home page
      And I should see the edit form for the 1st battle
      And I should see 2 battles

    @javascript
    Scenario: Cancelling new battle creation
      When I go to the home page
      And I press the button to edit 1st battle
      And I cancel battle edition
      Then I should be on the home page
      And I should not see the edit battle form for 1st battle
      And I should see 3 battles


