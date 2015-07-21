Feature: Control of Access Permissions for Battles
  An user may have different permissions for accessing Battles
  depending on his roles

Background: I exist as an user and there are battles in database
    Given I am logged in
    And the following battles were added:
    | starts_at                 | duration  |
    | 2015-05-18 10:30:14 -0300 | 5760      |
    | 2015-05-20 12:30:20 -0300 | 8940      |

    @javascript
    Scenario: Admin can create battles
      Given I am an admin
      When I go to the home page
      Then I should be on the home page
      And I should see the button to add battles

    @javascript
    Scenario: Admin can remove battles
      Given I am an admin
      When I go to the home page
      Then I should be on the home page
      And I should see the button to remove 1st battle

    @javascript
    Scenario: Admin can edit battles
      Given I am an admin
      When I go to the home page
      Then I should be on the home page
      And I should see the button to edit 2nd battle

