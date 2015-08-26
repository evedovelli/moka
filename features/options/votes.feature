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
    Scenario: User cannot see the list of votes for an option before clicking it
      When I go to my home page
      Then I should not see voters for "Devil"
      And I should not see voters for "Vader"
      And I should not see voters for "Horror"

    @javascript
    Scenario: User can see the list of votes for an option after clicking it
      When I go to my home page
      And I click to see voters for "Vader"
      And I click to see voters for "Devil"
      Then I should see the 10 voters for "Vader"
      And I should see the 5 voters for "Devil"
      And I should not see voters for "Horror"

