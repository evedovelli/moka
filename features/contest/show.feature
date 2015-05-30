Feature: Show
  To know about the audience, and about the contest results
  An admininstrator should be able to see the statistics in the contest page

Background:
    Given I am logged in
    And I am an admin
    And the following stuffs were added:
    | name     | picture  |
    | Robson   | 2        |
    | Roberta  | 4        |
    And an contest was created with stuffs "Robson" and "Roberta" starting 3 hours ago
    And I am on the contest index page

    Scenario: Admin can consult statistics for contest
      Given "Robson" had 5 votes 2 hours ago
      And "Robson" had 4 votes 1 hours ago
      And "Roberta" had 6 votes 1 hours ago
      And "Roberta" had 2 votes just now
      When I follow "Statistics"
      Then I should see total of votes 17
      And I should see 9 votes for "Robson"
      And I should see 8 votes for "Roberta"
      And I should see 5 votes in the 2nd hour
      And I should see 10 votes in the 3rd hour
      And I should see 2 votes in the 4th hour

