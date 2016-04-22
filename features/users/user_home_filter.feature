Feature: Filter battles by current and finished in home page
  Some users want to look at the finished battles to see results,
  other users want to look at the battles in course to vote.
  To improve user experience and show user the content he is interested in,
  An user should be able to filter only current or finished battles.

Background: I am a registered user logged in and battles exist
    Given I am logged in
    And user "willywallace" exists
    And I am following "willywallace"
    And the following battles were added:
    | starts_at                 | duration  | user         | title        |
    | 2015-10-01 10:30:00 -0300 | 6000      | myself       | first battle |
    | 2015-10-02 10:30:00 -0300 | 30000     | willywallace | battle 2     |
    | 2015-10-03 10:30:00 -0300 | 100000    | myself       | battle 3     |
    | 2015-10-04 10:30:00 -0300 | 3000      | willywallace | battle 4     |
    | 2015-10-04 11:30:00 -0300 | 3000      | willywallace | battle 5     |
    | 2015-10-05 10:30:00 -0300 | 6000      | myself       | battle 6     |
    | 2015-10-06 10:30:00 -0300 | 30000     | willywallace | battle 7     |
    | 2015-10-07 10:30:00 -0300 | 58000     | myself       | battle 8     |
    | 2015-10-08 10:30:00 -0300 | 3000      | willywallace | battle 9     |
    | 2015-10-08 11:30:00 -0300 | 30000     | willywallace | battle 10    |
    | 2015-10-09 10:30:00 -0300 | 58000     | myself       | battle 11    |
    | 2015-10-10 10:30:00 -0300 | 58000     | myself       | battle 12    |
    | 2015-10-11 10:30:00 -0300 | 3000      | willywallace | battle 13    |
    And current time is 2015-10-11 10:31:00 -0300

    @javascript
    Scenario: I can see all battles when filtering by all
      When I go to my home page
      And I select filter "All"
      And I scroll to the bottom of the page
      And I wait 1 second
      And I scroll to the bottom of the page
      Then I should see the battle title "first battle"
      And I should see 13 battles

    @javascript
    Scenario: I can see current battles when filtering by current
      When I go to my home page
      And I select filter "Current"
      And I scroll to the bottom of the page
      And I wait 1 second
      And I scroll to the bottom of the page
      Then I should see the battle title "battle 3"
      And I should not see the battle title "battle 4"
      And I should see 8 battles

    @javascript
    Scenario: I can see finished battles when filtering by finished
      When I go to my home page
      And I select filter "Finished"
      And I scroll to the bottom of the page
      And I wait 1 second
      And I scroll to the bottom of the page
      Then I should see the battle title "battle 4"
      And I should not see the battle title "battle 3"
      And I should see 5 battles
