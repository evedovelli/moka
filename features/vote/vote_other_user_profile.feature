Feature: Voting in battles from other users profile page
  To encourage a user to search for other users and stay more time at the website
  An user should be able to vote in battles from an user's profile

Background: I exist as an user, and another user has created some battles
    Given I am logged in
    And user "willywonka" exists
    And current time is 1985-10-21 07:28:00 -0300
    And a battle was created by "willywonka" with options:
    | name            | image              |
    | Devil Robot     | devil_robot.jpg    |
    | Darth Vader     | vader.jpg          |
    And a battle was created by "willywonka" with options:
    | name            | image              |
    | Dick Dastardly  | dick_dastardly.jpg |
    | Palpatine       | palpatine.jpg      |

    @javascript
    Scenario: I can vote in a battle from another user's profile
      When I go to the "willywonka" profile page
      And I vote for "Dick Dastardly" for the 1st battle
      Then I should see "Dick Dastardly" option selected for the 1st battle
      And I should be on the "willywonka" profile page
      And I should see 1 vote for "Dick Dastardly" for the 1st battle
      And I should see 0 votes for "Palpatine" for the 1st battle

    @javascript
    Scenario: I can vote in many battles from another user's profile
      When I go to the "willywonka" profile page
      And I vote for "Dick Dastardly" for the 1st battle
      And I vote for "Darth Vader" for the 2nd battle
      Then I should be on the "willywonka" profile page
      And I should see "Dick Dastardly" option selected for the 1st battle
      And I should see 1 vote for "Dick Dastardly" for the 1st battle
      And I should see 0 votes for "Palpatine" for the 1st battle
      And I should see "Darth Vader" option selected for the 2nd battle
      And I should see 1 vote for "Darth Vader" for the 2nd battle
      And I should see 0 votes for "Devil Robot" for the 2nd battle

    @javascript
    Scenario: I cannot vote in finished battles
      Given current time is 2015-10-21 07:28:00 -0300
      When I go to the "willywonka" profile page
      And I vote for "Dick Dastardly" for the 1st battle
      Then I should be on the "willywonka" profile page
      And I should not see "Dick Dastardly" option selected for the 1st battle
      And I should see 0 votes for "Dick Dastardly" for the 1st battle
      And I should see 0 votes for "Palpatine" for the 1st battle

