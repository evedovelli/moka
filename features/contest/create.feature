Feature: Create contest
  To allow users to vote between stuffs to get out of the house
  An admin should be able to fill and submit the new contest form

Background:
    Given I am logged in
    And I am an admin
    And the following stuffs were added:
    | name     | picture  |
    | Joseane  | 1        |
    | Arthur   | 2        |
    | Andréia  | 3        |
    And I am on the contest index page
    And I press the button to add new contest

    @javascript
    Scenario: Creation of a new contest
      When I check "Arthur"
      And I check "Andréia"
      And I select datetime "2015 06 28 - 10:11" as the "contest_starts_at"
      And I select datetime "2015 06 30 - 10:11" as the "contest_finishes_at"
      And I press "Create"
      Then I should be on the contest index page
      And I should see the contest that starts on "28/06/15 - 10:11"
      And I should see "Arthur"
      And I should see "Andréia"

    @javascript
    Scenario: Missing bothers
      When I check "Arthur"
      And I select datetime "2015 06 28 - 10:11" as the "contest_starts_at"
      And I select datetime "2015 06 30 - 10:11" as the "contest_finishes_at"
      And I press "Create"
      Then I should be on the contest index page
      And I should see an error for the number of stuffs

    @javascript
    Scenario: Timing errors
      When I check "Arthur"
      And I select datetime "2015 06 28 - 10:11" as the "contest_starts_at"
      And I select datetime "2015 06 26 - 10:11" as the "contest_finishes_at"
      And I press "Create"
      Then I should be on the contest index page
      And I should see an error for finishes_at

