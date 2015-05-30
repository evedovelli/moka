Feature: Create stuff
  To incentivate users to watch the show and interact with it
  Users should be able to vote in contests to eliminate
  the stuffs they want to get out of the house

Background: There is an contest running
    Given the following stuffs were added:
    | name     | picture  |
    | Joseane  | 1        |
    | Arthur   | 2        |
    | Andréia  | 3        |
    | Jaime    | 4        |
    And an contest was created with stuffs "Joseane", "Jaime" and "Andréia"

    @javascript
    Scenario: User votes to a stuff and see its vote was successful
      Given I am on the home page
      When I vote for "Andréia"
      Then I should be on the home page
      And I should see "Congratulations! Your vote for Andréia was successfully sent."

    @javascript
    Scenario: User votes to a stuff and see its vote was successful
      Given "Joseane" has 5 votes
      And "Jaime" has 4 votes
      And "Andréia" has 10 votes
      And I am on the home page
      When I vote for "Jaime"
      Then I should see "Jaime" with 25.0% of votes
      And I should see "Joseane" with 25.0% of votes
      And I should see "Andréia" with 50.0% of votes

    @javascript
    Scenario: User votes to a stuff and then votes again
      Given I am on the home page
      When I vote for "Jaime"
      And I close the results overlay
      And I vote for "Joseane"
      Then I should see "Jaime" with 50.0% of votes
      And I should see "Joseane" with 50.0% of votes
      And I should see "Andréia" with 0.0% of votes

    @javascript
    Scenario: User cannot vote if it is a robot
      Given captcha is enabled
      And I am on the home page
      When I vote for "Jaime"
      Then I wait 1 second
      And I should see "Are you a robot? If you aren't, please check option and try again!"
      And captcha should be disabled

    @javascript
    Scenario: User must choose a stuff before voting
      Given I am on the home page
      When I press the button to vote
      Then I should see "Stuff can't be blank"

