Feature: User's profile
  To allow an user visualize his own created battle
  or all the battles of another user to decide if he should or
  not follow this user
  An user should be able to access his and others user profiles

Background: I am a registered user logged in and battles exist
    Given I am logged in
    And user "willywallace" exists
    And the following battles were added:
    | starts_at                 | duration  | user         |
    | 2015-10-01 10:30:00 -0300 | 6000      | myself       |
    | 2015-10-12 10:30:00 -0300 | 30000     | willywallace |
    | 2015-10-16 10:30:00 -0300 | 58000     | myself       |
    | 2015-10-20 10:30:00 -0300 | 3000      | willywallace |
    And current time is 2015-10-21 07:28:00 -0300

    Scenario: I can see only battles from the user in his profile page
      When I go to the "willywallace" profile page
      Then I should see the battle that starts on "12/10/15 - 10:30"
      And I should see the battle that starts on "20/10/15 - 11:30"
      And I should not see the battle that starts on "01/10/15 - 10:30"
      And I should not see the battle that starts on "16/10/15 - 10:30"

    Scenario: I can see my battles in my profile page
      When I go to my profile page
      Then I should not see the battle that starts on "12/10/15 - 10:30"
      And I should not see the battle that starts on "20/10/15 - 11:30"
      And I should see the battle that starts on "01/10/15 - 10:30"
      And I should see the battle that starts on "16/10/15 - 10:30"

    @javascript
    Scenario: I can create battles in my profile page
      When I go to my profile page
      Then I should see "#add_battle" css element
      And I press the button to add new battle
      And I should be on my profile page
      And I should see the new battle form

    Scenario: I cannot create battles in others' profile page
      When I go to the "willywallace" profile page
      Then I should not see "#add_battle" css element

    Scenario: I should always see partials in my profile page
      When I go to my profile page
      Then I should see votes for 1st battle
      And I should see votes for 2nd battle

    Scenario: I should not see partials for current battles in others' profile page
      When I go to the "willywallace" profile page
      Then I should not see votes for 1st battle
      And I should not see votes for 2nd battle

    Scenario: I should see results for finished battles in my profile page
      Given current time is 2016-10-21 07:28:00 -0300
      When I go to my profile page
      Then I should see votes for 1st battle
      And I should see votes for 2nd battle

    Scenario: I should see results for finished battles in others' profile page
      Given current time is 2016-10-21 07:28:00 -0300
      When I go to the "willywallace" profile page
      Then I should see votes for 1st battle
      And I should see votes for 2nd battle

