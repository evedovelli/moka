Feature: Show votes of an option
  To let users find other users and discover who else
  has voted in battles
  An user should be able to see the list of users
  who had voted for an option

Background: There is a battle running
    Given I am logged in
    And a battle was created with options "Devil", "Horror" and "Vader"
    And "Devil" has 5 votes
    And "Horror" has 4 votes
    And "Vader" has 10 votes

    @javascript
    Scenario: No link to voters when there is no vote
      Given a battle was created with options "Bigger", "Better" and "Stronger"
      When I go to my home page
      Then I should not see a link to the votes page for option "Bigger"
      And I should not see a link to the votes page for option "Better"
      And I should not see a link to the votes page for option "Stronger"

    @javascript
    Scenario: User cannot see the list of votes for an option before clicking it
      When I go to my home page
      Then I should not see voters for "Devil"
      And "5 votes" should link to the votes page for option "Devil"
      And I should not see voters for "Vader"
      And "10 votes" should link to the votes page for option "Vader"
      And I should not see voters for "Horror"
      And "4 votes" should link to the votes page for option "Horror"

    @javascript
    Scenario: User can see the list of votes for an option after clicking it
      When I go to my home page
      And I click to see voters for "Vader"
      Then I should see the 10 voters for "Vader"
      And I should not see voters for "Devil"
      And I should not see voters for "Horror"

    @javascript
    Scenario: User can close list of votes for an option and open other list
      When I go to my home page
      And I click to see voters for "Vader"
      And I should see the 10 voters for "Vader"
      And I close the modal window
      And I click to see voters for "Devil"
      Then I should see the 5 voters for "Devil"
      And I should not see voters for "Vader"
      And I should not see voters for "Horror"

