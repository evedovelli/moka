Feature: Create battle
  To allow users to vote between options to get out of the house
  An admin should be able to fill and submit the new battle form

Background:
    Given I am logged in
    And I am an admin
    And I am on the battle index page
    And I press the button to add new battle

    @javascript
    Scenario: Creation of a new battle
      When I add 1st option with name "Arthur" and picture 2
      And I add 2nd option with name "Andréia" and picture 3
      And I select datetime "2015 06 28 - 10:11" as the "battle_starts_at"
      And I select datetime "2015 06 30 - 10:11" as the "battle_finishes_at"
      And I press "Create"
      Then I should be on the battle index page
      And I should see the battle that starts on "28/06/15 - 10:11"
      And I should see "Arthur"
      And I should see "Andréia"

    @javascript
    Scenario: Missing bothers
      When I add 1st option with name "Arthur" and picture 2
      And I remove 2nd option
      And I select datetime "2015 06 28 - 10:11" as the "battle_starts_at"
      And I select datetime "2015 06 30 - 10:11" as the "battle_finishes_at"
      And I press "Create"
      Then I should be on the battle index page
      And I should see an error for the number of options

    @javascript
    Scenario: Timing errors
      When I add 1st option with name "Arthur" and picture 2
      When I add 2nd option with name "Joseane" and picture 1
      And I select datetime "2015 06 28 - 10:11" as the "battle_starts_at"
      And I select datetime "2015 06 26 - 10:11" as the "battle_finishes_at"
      And I press "Create"
      Then I should be on the battle index page
      And I should see an error for finishes_at

