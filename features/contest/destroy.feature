Feature: Destroy
  When an admin has created a stuff with an error
  He should be able to destroy the stuff

Background:
    Given I am logged in
    And I am an admin
    And the following contests were added:
    | starts_at                 | finishes_at               |
    | 2015-05-01 10:30:14 -0300 | 2015-05-14 10:30:15 -0300 |
    | 2015-05-22 10:30:14 -0300 | 2015-05-25 10:30:15 -0300 |
    | 2015-05-26 10:30:14 -0300 | 2015-05-29 10:30:15 -0300 |
    And I am on the contest index page

    @javascript
    Scenario: Admin can destroy contest
      When I follow the link to remove 1st contest
      And I confirm popup
      Then I should be on the contest index page
      And I should see 2 contests
      And I should not see the contest that starts on "18/05/15 - 10:30"

    @javascript
    Scenario: Designer can cancel destruction of contest
      When I follow the link to remove 1st contest
      And I dismiss popup
      Then I should be on the contest index page
      And I should see 3 contests


