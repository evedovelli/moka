Feature: Create vote
  To incentivate users to watch the show and interact with it
  Users should be able to vote in battles to eliminate
  the options they want to get out of the house

Background: There is a battle running
    Given a battle was created with options "Joseane", "Jaime" and "Andréia"

    @javascript
    Scenario: User votes to a option and see its vote was successful
      Given I am on the home page
      When I vote for "Andréia"
      Then I should be on the home page
      And I should see "Your vote for Andréia was successfully sent."

    @javascript
    Scenario: User votes to a option and see its vote was successful
      Given "Joseane" has 5 votes
      And "Jaime" has 4 votes
      And "Andréia" has 10 votes
      And I am on the home page
      When I vote for "Jaime"
      Then I should see "Jaime" with 25.0% of votes
      And I should see "Joseane" with 25.0% of votes
      And I should see "Andréia" with 50.0% of votes

    @javascript
    Scenario: User votes to a option and then votes again
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
    Scenario: User must choose a option before voting
      Given I am on the home page
      When I press the button to vote
      Then I should see "Option can't be blank"

