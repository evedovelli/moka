Feature: User's home page
  To allow an user visualize the battle of his fellows
  An user should be able to access receive feeds in his home page

Background: I am a registered user logged in and battles exist
    Given I am logged in
    And user "willywallace" exists
    And user "macewindu" exists
    And I am following "willywallace"
    And the following battles were added:
    | starts_at                 | duration  | user         | title     |
    | 2015-10-01 10:30:00 -0300 | 6000      | myself       | battle 1  |
    | 2015-10-12 10:30:00 -0300 | 30000     | willywallace | battle 2  |
    | 2015-10-13 10:30:00 -0300 | 3000      | macewindu    | battle 3  |
    | 2015-10-16 10:30:00 -0300 | 58000     | myself       | battle 4  |
    | 2015-10-20 10:30:00 -0300 | 3000      | willywallace | battle 5  |
    | 2015-10-22 10:30:00 -0300 | 4000      | macewindu    | battle 6  |
    And current time is 2015-10-21 07:28:00 -0300


    Scenario: I can see battles I submit
      When I go to my home page
      Then I should see the battle title "battle 1"
      And I should see the battle title "battle 4"

    Scenario: I can see battles from my following list
      When I go to my home page
      Then I should see the battle title "battle 2"
      And I should see the battle title "battle 5"

    Scenario: I should not see battles if user is not in my following list
      When I go to my home page
      Then I should not see the battle title "battle 3"
      And I should not see the battle title "battle 6"

    Scenario: I can see mine and others battles ordered by starting time
      When I go to my home page
      Then I should see "battle 4" after "battle 5"
      And I should see "battle 2" after "battle 4"
      And I should see "battle 1" after "battle 2"

    @javascript
    Scenario: I can create battles in my home page
      When I go to my home page
      And I press the button to add new battle
      Then I should be on the home page
      And I should see the new battle form

    Scenario: I can click on user and go to the user's profile
      When I go to my home page
      And I click in "willywallace" within 1st battle
      Then I should be on the "willywallace" profile page

    Scenario: I should always see partials for my battles
      When I go to my home page
      Then I should see votes for 2nd battle
      And I should see votes for 4th battle

    Scenario: I should not see partials for others' current battles
      When I go to my home page
      Then I should not see votes for 1st battle
      And I should not see votes for 3rd battle

    Scenario: I should see results for finished battles
      Given current time is 2016-10-21 07:28:00 -0300
      When I go to my home page
      Then I should see votes for 1st battle
      And I should see votes for 2nd battle
      And I should see votes for 3rd battle
      And I should see votes for 4th battle

