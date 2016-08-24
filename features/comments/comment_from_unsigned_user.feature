Feature: Comment from unsigned user
  To avoid comments from unreal people
  Users should be requested to log in when trying to comment

Background: There is a battle running
    Given I exist as an user
    And user "Mickey" exists
    And a battle was created with options "Jake" and "Finn"
    And "Mickey" has commented "Oh boy!" for "Jake"

    Scenario: User can see latest comments
      When I go to the 1st battle page
      Then I should see "Oh boy!"

    @javascript
    Scenario: User is prompted to login when trying to comment
      Given I am on the 1st battle page
      When I click to comment for option "Jake"
      Then I should be prompted to log in

    @javascript
    Scenario: User logs in with his credentials
      Given I am on the 1st battle page
      When I click to comment for option "Jake"
      And I sign in from modal form
      Then I see a successful sign in message
      And I should be on the 1st battle page
      And I should see "Oh boy!"

    @javascript
    Scenario: User logs in with his Facebook account
      Given I accept to share my Facebook info:
      | email             | name       | picture      | verified  |
      | myself@email.com  | Marceline  | profile.jpg  | true      |
      And I am on the 1st battle page
      When I click to comment for option "Jake"
      And I click in the Sign in with Facebook button
      Then I see a successful sign in from Facebook message
      And I should be on the 1st battle page
      And I should see "Oh boy!"
