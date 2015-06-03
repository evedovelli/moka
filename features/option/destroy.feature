Feature: Destroy
  When an admin has created a option with an error
  He should be able to destroy the option

Background:
    Given I am logged in
    And I am an admin
    And the following options were added:
    | name     | picture  |
    | Joseane  | 1        |
    | Arthur   | 2        |
    | Andréia  | 3        |
    And I am on the option index page

    @javascript
    Scenario: Admin can destroy option
      When I follow the link to remove option "Arthur"
      And I confirm popup
      Then I should be on the option index page
      And I should not see "Arthur"
      And I should see "Joseane"
      And I should see "Andréia"

    @javascript
    Scenario: Designer can cancel destruction of option
      When I follow the link to remove option "Arthur"
      And I dismiss popup
      Then I should be on the option index page
      And I should see "Arthur"


