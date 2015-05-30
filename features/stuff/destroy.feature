Feature: Destroy
  When an admin has created a stuff with an error
  He should be able to destroy the stuff

Background:
    Given I am logged in
    And I am an admin
    And the following stuffs were added:
    | name     | picture  |
    | Joseane  | 1        |
    | Arthur   | 2        |
    | Andréia  | 3        |
    And I am on the stuff index page

    @javascript
    Scenario: Admin can destroy stuff
      When I follow the link to remove stuff "Arthur"
      And I confirm popup
      Then I should be on the stuff index page
      And I should not see "Arthur"
      And I should see "Joseane"
      And I should see "Andréia"

    @javascript
    Scenario: Designer can cancel destruction of stuff
      When I follow the link to remove stuff "Arthur"
      And I dismiss popup
      Then I should be on the stuff index page
      And I should see "Arthur"


