Feature: User's home page infinite scrolling
  To improve user experience and keep user in website for longer timer
  An user should keep fed by battles when scrolling the window in home page

Background: I am a registered user logged in and battles exist
    Given I am logged in
    And user "willywallace" exists
    And user "macewindu" exists
    And I am following "willywallace"
    And the following battles were added:
    | starts_at                 | duration  | user         | title        |
    | 2015-10-01 10:30:00 -0300 | 6000      | myself       | first battle |
    | 2015-10-02 10:30:00 -0300 | 30000     | willywallace | battle 2     |
    | 2015-10-03 10:30:00 -0300 | 58000     | myself       | battle 3     |
    | 2015-10-04 10:30:00 -0300 | 3000      | willywallace | battle 4     |
    | 2015-10-04 11:30:00 -0300 | 3000      | macewindu    | battle 5     |
    | 2015-10-05 10:30:00 -0300 | 6000      | myself       | battle 6     |
    | 2015-10-06 10:30:00 -0300 | 30000     | willywallace | battle 7     |
    | 2015-10-07 10:30:00 -0300 | 58000     | myself       | battle 8     |
    | 2015-10-08 10:30:00 -0300 | 3000      | willywallace | battle 9     |
    | 2015-10-08 11:30:00 -0300 | 3000      | macewindu    | battle 10    |
    | 2015-10-09 10:30:00 -0300 | 58000     | myself       | battle 11    |
    | 2015-10-10 10:30:00 -0300 | 58000     | myself       | battle 12    |
    | 2015-10-11 10:30:00 -0300 | 3000      | willywallace | battle 13    |
    And current time is 2015-10-21 07:28:00 -0300

    @javascript
    Scenario: I can only see first page home battles before scrolling
      When I go to my home page
      Then I should see the battle title "battle 13"
      And I should see the battle title "battle 12"
      And I should see the battle title "battle 11"
      And I should see the battle title "battle 9"
      And I should see the battle title "battle 8"
      And I should not see the battle title "battle 7"
      And I should not see the battle title "battle 6"
      And I should not see the battle title "battle 10"
      And I should see 5 battles

    @javascript
    Scenario: I can see next page home battles when scrolling
      When I go to my home page
      And I scroll to the bottom of the page
      Then I should see the battle title "battle 13"
      And I should see the battle title "battle 12"
      And I should see the battle title "battle 11"
      And I should see the battle title "battle 9"
      And I should see the battle title "battle 8"
      And I should see the battle title "battle 7"
      And I should see the battle title "battle 6"
      And I should see the battle title "battle 4"
      And I should see the battle title "battle 3"
      And I should see the battle title "battle 2"
      And I should not see the battle title "battle 5"
      And I should not see the battle title "first battle"
      And I should see 10 battles

    @javascript
    Scenario: Pages are loaded when user scrolls to the bottom
      When I go to my home page
      And I scroll to the bottom of the page
      And I wait 1 second
      And I scroll to the bottom of the page
      Then I should see the battle title "battle 13"
      And I should see the battle title "battle 12"
      And I should see the battle title "battle 11"
      And I should see the battle title "battle 9"
      And I should see the battle title "battle 8"
      And I should see the battle title "battle 7"
      And I should see the battle title "battle 6"
      And I should see the battle title "battle 4"
      And I should see the battle title "battle 3"
      And I should see the battle title "battle 2"
      And I should see the battle title "first battle"
      And I should not see the battle title "battle 5"
      And I should not see the battle title "battle 10"
      And I should see 11 battles

    @javascript
    Scenario: Create battle within loaded page
      When I go to my home page
      And I press the button to add new battle
      And I add 1st option "Vader" with picture "vader.jpg"
      And I add 2nd option "Palpatine" with picture "palpatine.jpg"
      And I press "Create"
      Then I should see "Vader"
      And I should see the battle title "battle 13"
      And I should see the battle title "battle 12"
      And I should see the battle title "battle 11"
      And I should see the battle title "battle 9"
      And I should not see the battle title "battle 8"
      And I should not see the battle title "battle 7"
      And I should see 5 battles

    @javascript
    Scenario: Create battle and scroll page
      When I go to my home page
      And I press the button to add new battle
      And I add 1st option "Vader" with picture "vader.jpg"
      And I add 2nd option "Palpatine" with picture "palpatine.jpg"
      And I press "Create"
      And I scroll to the bottom of the page
      Then I should see "Vader"
      And I should see the battle title "battle 13"
      And I should see the battle title "battle 12"
      And I should see the battle title "battle 11"
      And I should see the battle title "battle 9"
      And I should see the battle title "battle 8"
      And I should see the battle title "battle 7"
      And I should see the battle title "battle 6"
      And I should see the battle title "battle 4"
      And I should see the battle title "battle 3"
      And I should not see the battle title "battle 2"
      And I should not see the battle title "first battle"
      And I should see 10 battles

    @javascript
    Scenario: Scroll page and then create battle
      When I go to my home page
      And I scroll to the bottom of the page
      And I wait 1 second
      And I scroll to the bottom of the page
      And I wait 1 second
      And I scroll to the top of the page
      And I wait 1 second
      And I press the button to add new battle
      And I add 1st option "Vader" with picture "vader.jpg"
      And I add 2nd option "Palpatine" with picture "palpatine.jpg"
      And I press "Create"
      Then I should see "Vader"
      And I should see the battle title "battle 13"
      And I should see the battle title "battle 12"
      And I should see the battle title "battle 11"
      And I should see the battle title "battle 9"
      And I should see the battle title "battle 8"
      And I should see the battle title "battle 7"
      And I should see the battle title "battle 6"
      And I should see the battle title "battle 4"
      And I should see the battle title "battle 3"
      And I should see the battle title "battle 2"
      And I should see the battle title "first battle"
      And I should see 12 battles

    @javascript
    Scenario: Delete battle and scroll page
      When I go to my home page
      And I remove my 1st battle
      And I confirm popup
      And I scroll to the bottom of the page
      Then I should see the battle title "battle 13"
      And I should not see the battle title "battle 12"
      And I should see the battle title "battle 11"
      And I should see the battle title "battle 9"
      And I should see the battle title "battle 8"
      And I should see the battle title "battle 7"
      And I should see the battle title "battle 6"
      And I should see the battle title "battle 4"
      And I should see the battle title "battle 3"
      And I should see the battle title "battle 2"
      And I should not see the battle title "first battle"
      And I should see 9 battles

