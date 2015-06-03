Feature: Create battle
  To allow users to vote between options to get out of the house
  An admin should be able to fill and submit the new battle form

Background:
    Given I am logged in
    And I am an admin
    And the following options were added:
    | name     | picture  |
    | Joseane  | 1        |
    | Arthur   | 2        |
    | Andréia  | 3        |
    And I am on the battle index page
    And I press the button to add new battle

    @javascript
    Scenario: Creation of a new battle
      When I check "Arthur"
      And I check "Andréia"
      And I select datetime "2015 06 28 - 10:11" as the "battle_starts_at"
      And I select datetime "2015 06 30 - 10:11" as the "battle_finishes_at"
      And I press "Create"
      Then I should be on the battle index page
      And I should see the battle that starts on "28/06/15 - 10:11"
      And I should see "Arthur"
      And I should see "Andréia"

    @javascript
    Scenario: Missing bothers
      When I check "Arthur"
      And I select datetime "2015 06 28 - 10:11" as the "battle_starts_at"
      And I select datetime "2015 06 30 - 10:11" as the "battle_finishes_at"
      And I press "Create"
      Then I should be on the battle index page
      And I should see an error for the number of options

    @javascript
    Scenario: Timing errors
      When I check "Arthur"
      And I select datetime "2015 06 28 - 10:11" as the "battle_starts_at"
      And I select datetime "2015 06 26 - 10:11" as the "battle_finishes_at"
      And I press "Create"
      Then I should be on the battle index page
      And I should see an error for finishes_at

