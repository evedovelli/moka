Feature: Destroy
  When an admin has created a option with an error
  He should be able to destroy the option

Background:
    Given I am logged in
    And I am an admin
    And the following battles were added:
    | starts_at                 | duration  |
    | 2015-05-01 10:30:14 -0300 | 60        |
    | 2015-05-22 10:30:14 -0300 | 300       |
    | 2015-05-26 10:30:14 -0300 | 580       |
    And I am on the battle index page

    @javascript
    Scenario: Admin can destroy battle
      When I follow the link to remove 1st battle
      And I confirm popup
      Then I should be on the battle index page
      And I should see 2 battles
      And I should not see the battle that starts on "18/05/15 - 10:30"

    @javascript
    Scenario: Designer can cancel destruction of battle
      When I follow the link to remove 1st battle
      And I dismiss popup
      Then I should be on the battle index page
      And I should see 3 battles


