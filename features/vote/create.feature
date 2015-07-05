Feature: Create vote
  To incentivate users to watch the show and interact with it
  Users should be able to vote in battles to eliminate
  the options they want to get out of the house

Background: There is a battle running
    Given a battle was created with options "Devil", "Horror" and "Vader"

    @javascript
    Scenario: User votes to a option and see its vote was successful
      Given I am on the home page
      When I vote for "Vader"
      Then I should be on the home page
      And I should see "Your vote for Vader was successfully sent."

    @javascript
    Scenario: User votes to a option and see its vote was successful
      Given "Devil" has 5 votes
      And "Horror" has 4 votes
      And "Vader" has 10 votes
      And I am on the home page
      When I vote for "Horror"
      Then I should see "Horror" with 25.0% of votes
      And I should see "Devil" with 25.0% of votes
      And I should see "Vader" with 50.0% of votes

    @javascript
    Scenario: User votes to a option and then votes again
      Given I am on the home page
      When I vote for "Horror"
      And I close the results overlay
      And I vote for "Devil"
      Then I should see "Horror" with 50.0% of votes
      And I should see "Devil" with 50.0% of votes
      And I should see "Vader" with 0.0% of votes

    @javascript
    Scenario: User cannot vote if it is a robot
      Given captcha is enabled
      And I am on the home page
      When I vote for "Horror"
      Then I wait 1 second
      And I should see "Are you a robot? If you aren't, please check option and try again!"
      And captcha should be disabled

    @javascript
    Scenario: User must choose a option before voting
      Given I am on the home page
      When I press the button to vote
      Then I should see "Option can't be blank"

