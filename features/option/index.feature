Feature: Index
  To list created options
  An user should be able to access the option index

Background:
    Given I am logged in
    And I am an admin
    And I am on the configuration page
    And the following options were added:
    | name     | picture  |
    | Joseane  | 1        |
    | Arthur   | 2        |
    | Andréia  | 3        |

    Scenario: User can access option index from config page
      When I follow "Options"
      Then I should be on the option index page
      And I should see "Joseane"
      And I should see "Arthur"
      And I should see "Andréia"

    Scenario: User return to config page when clicking back in template index
      When I follow "Options"
      And I follow "Back"
      Then I should be on the configuration page

