Feature: Search for a hashtag
  To allow users to search battles of his interest
  An user should be able to search by a hashtag of interest

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
    Scenario: Search for hashtag
      Given I am on the "doc" profile page
      When I search for hashtag with "anything"
      Then I should see 5 battles
      And I should see the battle title "Choose #anything 1"
      And I should see the battle title "Choose #anything 5"
      And I should not see the battle title "#Choose anything 0"
      And I should not see the battle title "Choose #anything 6"
      And I should be on the "anything" hashtag page

    Scenario: Search for hashtag without search word
      Given I am on the "doc" profile page
      When I search for hashtag with ""
      Then I should be on the home page

