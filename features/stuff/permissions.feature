Feature: Control of Access Permissions for Stuffs
  An user may have different permissions for accessing Stuffs
  depending on his roles

Background: I exist as an user and there are stuffs in database
    Given I am logged in
    And the following stuffs were added:
    | name     | picture  |
    | Joseane  | 1        |
    | Arthur   | 2        |
    | Andréia  | 3        |

    Scenario: Admin can create stuffs
      Given I am an admin
      When I go to the stuff index page
      Then I should be on the stuff index page
      And I should see the button to add stuffs

    Scenario: Users cannot create stuffs
      When I go to the stuff index page
      Then I should be on the stuff index page
      And I should not see the button to add stuffs

    Scenario: Admin can remove stuffs
      Given I am an admin
      When I go to the stuff index page
      Then I should be on the stuff index page
      And I should see the button to remove "Joseane"

    Scenario: Users cannot remove stuffs
      When I go to the stuff index page
      Then I should be on the stuff index page
      And I should not see the button to remove "Joseane"

