Feature: Single vote per user
  To avoid bots and to have fair battles
  A single vote should be allowed for an user per battle

Background: There is a battle running
    Given I am logged in
    And a battle was created with options "Devil", "Horror" and "Vader"

    @javascript
    Scenario: User votes to an option and try to vote again in same option
      Given I am on the home page
      When I vote for "Horror"
      And I vote for "Horror"
      And I wait 1 second
      Then I should see "Horror" with 1 vote
      And I should see "Devil" with 0 votes
      And I should see "Vader" with 0 votes
      And I should see "Horror" option selected

    @javascript
    Scenario: User votes to an option and then votes again
      Given I am on the home page
      When I vote for "Horror"
      And I vote for "Devil"
      And I wait 1 second
      Then I should see "Horror" with 0 votes
      And I should see "Devil" with 1 vote
      And I should see "Vader" with 0 votes
      And I should see "Devil" option selected
      And I should not see "Horror" option selected

    @javascript
    Scenario: User see its voted options selected when accessing the page
      Given I have voted for "Vader"
      When I go to the home page
      Then I should see "Vader" option selected
      And I should not see "Horror" option selected
      And I should not see "Devil" option selected


