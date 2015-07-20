Feature: Voting in battles from own user's profile page
  To allow an user to participate in its own battles
  and visit his own profile to create more battles
  An user should be able to vote in battles from his user's profile

Background: I exist as an user, and I have created some battles
    Given I am logged in
    And current time is 1985-10-21 07:28:00 -0300
    And a battle was created by "myself" with options:
    | name            | image              |
    | Devil Robot     | devil_robot.jpg    |
    | Darth Vader     | vader.jpg          |
    And a battle was created by "myself" with options:
    | name            | image              |
    | Dick Dastardly  | dick_dastardly.jpg |
    | Palpatine       | palpatine.jpg      |

    @javascript
    Scenario: I can vote in a battle from my user's profile
      When I go to my profile page
      And I vote for "Dick Dastardly" for the 1st battle
      Then I should see "Dick Dastardly" option selected for the 1st battle
      And I should be on my profile page
      And I should see 1 vote for "Dick Dastardly" for the 1st battle
      And I should see 0 votes for "Palpatine" for the 1st battle

    @javascript
    Scenario: I can vote in many battles from my user's profile
      When I go to my profile page
      And I vote for "Dick Dastardly" for the 1st battle
      And I vote for "Darth Vader" for the 2nd battle
      Then I should be on my profile page
      And I should see "Dick Dastardly" option selected for the 1st battle
      And I should see 1 vote for "Dick Dastardly" for the 1st battle
      And I should see 0 votes for "Palpatine" for the 1st battle
      And I should see "Darth Vader" option selected for the 2nd battle
      And I should see 1 vote for "Darth Vader" for the 2nd battle
      And I should see 0 votes for "Devil Robot" for the 2nd battle

    @javascript
    Scenario: I cannot vote in finished battles in my user's profile
      Given current time is 2015-10-21 07:28:00 -0300
      When I go to my profile page
      And I vote for "Dick Dastardly" for the 1st battle
      Then I should be on my profile page
      And I should not see "Dick Dastardly" option selected for the 1st battle
      And I should see 0 votes for "Dick Dastardly" for the 1st battle
      And I should see 0 votes for "Palpatine" for the 1st battle

    @javascript
    Scenario: I create a battle from my profile and I vote in the new battle
      When I am on my profile page
      And I press the button to add new battle
      And I add 1st option "Dastardly" with picture "dick_dastardly.jpg"
      And I add 2nd option "Robot" with picture "devil_robot.jpg"
      And I press "Create"
      And I wait 3 seconds for uploading images
      And I vote for "Robot" for the 1st battle
      Then I should be on my profile page
      And I should see "Robot" option selected for the 1st battle
      And I should see 0 votes for "Dastardly" for the 1st battle
      And I should see 1 votes for "Robot" for the 1st battle

    @javascript
    Scenario: I create a battle from my profile and I vote in the previous battles
      When I am on my profile page
      And I press the button to add new battle
      And I add 1st option "Dastardly" with picture "dick_dastardly.jpg"
      And I add 2nd option "Robot" with picture "devil_robot.jpg"
      And I press "Create"
      And I wait 3 seconds for uploading images
      And I vote for "Palpatine" for the 2nd battle
      Then I should be on my profile page
      And I should see "Palpatine" option selected for the 2nd battle
      And I should see 0 votes for "Dick Dastardly" for the 2nd battle
      And I should see 1 votes for "Palpatine" for the 2nd battle

