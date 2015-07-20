Feature: Create vote
  To incentivate users to watch the show and interact with it
  Users should be able to vote in battles to eliminate
  the options they want to get out of the house

Background: There is a battle running
    Given I am logged in
    And a battle was created with options "Devil", "Horror" and "Vader"

    @javascript
    Scenario: User votes to an option and see its vote was successful
      Given I am on the home page
      When I vote for "Vader"
      Then I should see "Vader" option selected
      And I should be on the home page

    @javascript
    Scenario: User votes to an option and see its vote was successful
      Given "Devil" has 5 votes
      And "Horror" has 4 votes
      And "Vader" has 10 votes
      And I am on the home page
      When I vote for "Horror"
      Then I should see "Horror" with 5 votes
      And I should see "Devil" with 5 votes
      And I should see "Vader" with 10 votes

    @javascript
    Scenario: User votes to an option and then votes again
      Given I am on the home page
      When I vote for "Horror"
      And I vote for "Devil"
      Then I should see "Horror" with 1 vote
      And I should see "Devil" with 1 vote
      And I should see "Vader" with 0 votes

