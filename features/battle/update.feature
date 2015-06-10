Feature: Update battle
  If a battle was created with a mistake
  An admin should be able to fill and update an edit form for a battle

Background:
    Given I am logged in
    And I am an admin
    And the following battles were added:
    | starts_at                 | finishes_at               |
    | 2015-05-18 10:30:14 -0300 | 2015-05-22 10:30:13 -0300 |
    And I am on the battle index page
    And I press the button to edit 1st battle

    @javascript
    Scenario: Update a battle
      When I select datetime "2015 04 28 - 10:11" as the "battle_starts_at"
      And I press "Update"
      Then I should be on the battle index page
      And I should see the battle that starts on "28/04/15 - 10:11"

    @javascript
    Scenario: Timing errors
      When I select datetime "2015 04 28 - 10:11" as the "battle_finishes_at"
      And I press "Update"
      Then I should be on the battle index page
      And I should see an error for finishes_at


