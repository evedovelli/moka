Feature: List battles with a hashtag
  To allow users to search battles of his interest
  An user should be access the hash of interest page

Background:
    Given user "marty" exists
    And user "doc" exists
    And the following battles were added:
    | starts_at                 | duration  | title               | user  |
    | 2015-06-20 10:30:11 -0300 | 5760      | Choose #anything 1  | marty |
    | 2015-06-20 09:30:11 -0300 | 5760      | Choose #anything 2  | doc   |
    | 2015-06-20 09:00:11 -0300 | 5760      | #Choose anything 0  | marty |
    | 2015-06-20 08:30:11 -0300 | 5760      | Choose #anything 3  | marty |
    | 2015-06-20 07:30:11 -0300 | 5760      | Choose #anything 4  | doc   |
    | 2015-06-20 07:00:11 -0300 | 5760      | #Choose anything 0  | marty |
    | 2015-06-20 06:30:11 -0300 | 5760      | Choose #anything 5  | marty |
    | 2015-06-20 05:30:11 -0300 | 5760      | Choose #anything 6  | marty |
    | 2015-06-20 04:30:11 -0300 | 5760      | Choose #anything 7  | doc   |
    And current time is 2015-06-21 07:28:00 -0300

    @javascript
    Scenario: First battles with are loaded when accessing hashtag page
      When I go to the "anything" hashtag page
      Then I should see 5 battles
      And I should see the battle title "Choose #anything 1"
      And I should see the battle title "Choose #anything 5"
      And I should not see the battle title "#Choose anything 0"
      And I should not see the battle title "Choose #anything 6"
      And I should be on the "anything" hashtag page

    @javascript
    Scenario: Auto scrolling for hashtag page
      When I go to the "anything" hashtag page
      And I scroll to the bottom of the page
      And I wait 1 second
      Then I should see 7 battles
      And I should see the battle title "Choose #anything 1"
      And I should see the battle title "Choose #anything 5"
      And I should see the battle title "Choose #anything 6"
      And I should not see the battle title "#Choose anything 0"
      And I should be on the "anything" hashtag page

    @javascript
    Scenario: No battles are displayed for inexisting hashtag
      When I go to the "delorean" hashtag page
      Then I should be on the "delorean" hashtag page
      Then I should see 0 battles

