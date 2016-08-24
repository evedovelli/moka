Feature: Vote from unsigned user
  To avoid votes from unreal people and more than 1 vote per person
  Users should be requested to log in when trying to vote

Background: There is a battle running
    Given I exist as an user
    And a battle was created with options "Jake" and "Finn"

    @javascript
    Scenario: User is prompted to login when trying to vote
      Given I am on the 1st battle page
      When I vote for "Jake"
      Then I should be prompted to log in

    @javascript
    Scenario: User logs in with his credentials
      Given I am on the 1st battle page
      When I vote for "Jake"
      And I sign in from modal form
      Then I see a successful sign in message
      And I should be on the 1st battle page
      And I should see "Jake" with 0 votes

    @javascript
    Scenario: User logs in with his Facebook account
      Given I accept to share my Facebook info:
      | email             | name       | picture      | verified  |
      | myself@email.com  | Marceline  | profile.jpg  | true      |
      And I am on the 1st battle page
      When I vote for "Finn"
      And I click in the Sign in with Facebook button
      Then I should be on the 1st battle page
      And I see a successful sign in from Facebook message
      And I should see "Finn" with 0 votes

