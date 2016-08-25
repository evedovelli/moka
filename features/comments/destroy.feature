Feature: Destroy comment
  An user should be able to destroy a comment he has mistakenly posted
  or an offensive comment from another user in his battle

Background: There is a battle running
    Given I am logged in

    @javascript
    Scenario: User can destroy his comments
      Given user "Mickey" exists
      And a battle was created by "Mickey" with options:
      | name            | image              |
      | Devil Robot     | devil_robot.jpg    |
      | Darth Vader     | vader.jpg          |
      And I have commented "Evil of evil" for "Devil Robot"
      When I go to the 1st battle page
      And I click to see comments for "Devil Robot"
      And I wait 1 second
      And I destroy comment "Evil of evil"
      Then I should be on the 1st battle page
      And I should not see "Evil of evil"

    @javascript
    Scenario: User can destroy others' comments in his battles
      Given user "Mickey" exists
      And a battle was created by "myself" with options:
      | name            | image              |
      | Devil Robot     | devil_robot.jpg    |
      | Darth Vader     | vader.jpg          |
      And "Mickey" has commented "Evil of evil" for "Devil Robot"
      When I go to the 1st battle page
      And I click to see comments for "Devil Robot"
      And I wait 1 second
      And I destroy comment "Evil of evil"
      Then I should be on the 1st battle page
      And I should not see "Evil of evil"

    @javascript
    Scenario: User cannot destroy others' comments in others' battles
      Given user "Mickey" exists
      And a battle was created by "Mickey" with options:
      | name            | image              |
      | Devil Robot     | devil_robot.jpg    |
      | Darth Vader     | vader.jpg          |
      And "Mickey" has commented "Evil of evil" for "Devil Robot"
      When I go to the 1st battle page
      And I click to see comments for "Devil Robot"
      And I wait 1 second
      Then I should not see button to destroy comment

    @javascript
    Scenario: User can destroy his latest comments
      Given user "Mickey" exists
      And a battle was created by "Mickey" with options:
      | name            | image              |
      | Devil Robot     | devil_robot.jpg    |
      | Darth Vader     | vader.jpg          |
      And I have commented "Evil of evil" for "Devil Robot"
      When I go to the 1st battle page
      And I destroy comment "Evil of evil" from "Devil Robot"
      Then I should be on the 1st battle page
      And I should not see "Evil of evil"

    @javascript
    Scenario: User can destroy others' latest comments in his battles
      Given user "Mickey" exists
      And a battle was created by "myself" with options:
      | name            | image              |
      | Devil Robot     | devil_robot.jpg    |
      | Darth Vader     | vader.jpg          |
      And "Mickey" has commented "Evil of evil" for "Devil Robot"
      When I go to the 1st battle page
      And I destroy comment "Evil of evil" from "Devil Robot"
      Then I should be on the 1st battle page
      And I should not see "Evil of evil"

    Scenario: User cannot destroy others' latest comments in others' battles
      Given user "Mickey" exists
      And a battle was created by "Mickey" with options:
      | name            | image              |
      | Devil Robot     | devil_robot.jpg    |
      | Darth Vader     | vader.jpg          |
      And "Mickey" has commented "Evil of evil" for "Devil Robot"
      When I go to the 1st battle page
      Then I should not see button to destroy comment
