Feature: Show votes of an option with pagination
  Voters show be shown, but if there are too many voters,
  it would be slow to load all of them at once
  so the list of users should be paginated
  to avoid slow pages for Users

Background: There is a battle running with many voters
    Given I am logged in
    And a battle was created with options "Devil", "Horror" and "Vader"
    And "Vader" has 35 votes

    @javascript
    Scenario: User can see first page of voters for an option after clicking the votes number
      When I go to my home page
      And I click to see voters for "Vader"
      Then I should see the 2 first voters for "Vader"
      And I should see from the 14th to the 15th voter for "Vader"
      And I should not see from the 16th to the 18th voter for "Vader"

    @javascript
    Scenario: User can load second page of voters for an option
      When I go to my home page
      And I click to see voters for "Vader"
      And I wait 1 second
      And I click to load more voters for "Vader"
      Then I should see the 2 first voters for "Vader"
      And I should see from the 14th to the 18th voter for "Vader"
      And I should see from the 29th to the 30th voter for "Vader"
      And I should not see from the 31th to the 32th voter for "Vader"

    @javascript
    Scenario: User can load all pages of voters for an option
      When I go to my home page
      And I click to see voters for "Vader"
      And I wait 1 second
      And I click to load more voters for "Vader"
      And I should see from the 14th to the 18th voter for "Vader"
      And I click to load more voters for "Vader"
      Then I should see from the 31th to the 35th voter for "Vader"

