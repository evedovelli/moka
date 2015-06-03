Feature: Control of Access Permissions for Options
  An user may have different permissions for accessing Options
  depending on his roles

Background: I exist as an user and there are options in database
    Given I am logged in
    And the following options were added:
    | name     | picture  |
    | Joseane  | 1        |
    | Arthur   | 2        |
    | Andréia  | 3        |

    Scenario: Admin can create options
      Given I am an admin
      When I go to the option index page
      Then I should be on the option index page
      And I should see the button to add options

    Scenario: Users cannot create options
      When I go to the option index page
      Then I should be on the option index page
      And I should not see the button to add options

    Scenario: Admin can remove options
      Given I am an admin
      When I go to the option index page
      Then I should be on the option index page
      And I should see the button to remove "Joseane"

    Scenario: Users cannot remove options
      When I go to the option index page
      Then I should be on the option index page
      And I should not see the button to remove "Joseane"

