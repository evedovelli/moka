Feature: Voting in home page
  The main purpose of the application is creating battles and letting users to vote
  It is essential to allow and user vote in battles feed to him in his home page

Background: I exist as an user, and I there are battles
    Given I am logged in
    And user "willywonka" exists
    And I am following "willywonka"
    And current time is 1985-10-21 07:28:00 -0300
    And a battle was created by "myself" with options:
    | name            | image              |
    | Devil Robot     | devil_robot.jpg    |
    | Darth Vader     | vader.jpg          |
    And a battle was created by "willywonka" with options:
    | name            | image              |
    | Dick Dastardly  | dick_dastardly.jpg |
    | Palpatine       | palpatine.jpg      |


    @javascript
    Scenario: I can vote in a battle from my home page
      When I go to my home page
      And I vote for "Dick Dastardly" for the 1st battle
      Then I should see "Dick Dastardly" option selected for the 1st battle
      And I should be on the home page
      And I should see 1 vote for "Dick Dastardly" for the 1st battle
      And I should see 0 votes for "Palpatine" for the 1st battle

    @javascript
    Scenario: I can vote in many battles from my home page
      When I go to my home page
      And I vote for "Dick Dastardly" for the 1st battle
      And I vote for "Darth Vader" for the 2nd battle
      Then I should be on the home page
      And I should see "Dick Dastardly" option selected for the 1st battle
      And I should see 1 vote for "Dick Dastardly" for the 1st battle
      And I should see 0 votes for "Palpatine" for the 1st battle
      And I should see "Darth Vader" option selected for the 2nd battle
      And I should see 1 vote for "Darth Vader" for the 2nd battle
      And I should see 0 votes for "Devil Robot" for the 2nd battle

    @javascript
    Scenario: I cannot vote in finished battles in my home page
      Given current time is 2015-10-21 07:28:00 -0300
      When I go to my home page
      And I vote for "Dick Dastardly" for the 1st battle
      Then I should be on the home page
      And I should not see "Dick Dastardly" option selected for the 1st battle
      And I should see 0 votes for "Dick Dastardly" for the 1st battle
      And I should see 0 votes for "Palpatine" for the 1st battle

    @javascript
    Scenario: I create a battle from my home page and I vote in the new battle
      When I am on the home page
      And I press the button to add new battle
      And I add 1st option "Dastardly" with picture "dick_dastardly.jpg"
      And I add 2nd option "Robot" with picture "devil_robot.jpg"
      And I press "Create"
      And I wait 4 seconds for uploading images
      And I vote for "Robot" for the 1st battle
      Then I should be on the home page
      And I should see "Robot" option selected for the 1st battle
      And I should see 0 votes for "Dastardly" for the 1st battle
      And I should see 1 votes for "Robot" for the 1st battle

    @javascript
    Scenario: I create a battle from my home page and I vote in the previous battles
      When I am on the home page
      And I press the button to add new battle
      And I add 1st option "Dastardly" with picture "dick_dastardly.jpg"
      And I add 2nd option "Robot" with picture "devil_robot.jpg"
      And I press "Create"
      And I wait 4 seconds for uploading images
      And I vote for "Palpatine" for the 2nd battle
      Then I should be on the home page
      And I should see "Palpatine" option selected for the 2nd battle
      And I should see 0 votes for "Dick Dastardly" for the 2nd battle
      And I should see 1 votes for "Palpatine" for the 2nd battle

