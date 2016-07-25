Feature: Index comments
  To see others' opinions in battles' options
  Users should be able to index comments

Background: There is a battle running
    Given I am logged in
    And a battle was created with options "Devil", "Horror" and "Vader"
    And there are 20 comments for "Vader"

    Scenario: User can see the two latest comments for option
      When I go to the 1st battle page
      Then I should see comments from 19 up to 20

    @javascript
    Scenario: User can see the latest comments in comments index
      When I go to the 1st battle page
      And I click to see comments for "Vader"
      Then I should see comments from 13 up to 20

    @javascript
    Scenario: User can load more comments index
      When I go to the 1st battle page
      And I click to see comments for "Vader"
      And I click to load more comments
      Then I should see comments from 5 up to 20

    @javascript
    Scenario: User can load yet more comments index
      When I go to the 1st battle page
      And I click to see comments for "Vader"
      And I click to load more comments
      And I click to load more comments
      Then I should see comments from 1 up to 20
