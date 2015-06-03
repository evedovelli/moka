Feature: Control of Access Permissions for Battles
  An user may have different permissions for accessing Battles
  depending on his roles

Background: I exist as an user and there are battles in database
    Given I am logged in
    And 2 battles were added

    Scenario: Admin can create battles
      Given I am an admin
      When I go to the battle index page
      Then I should be on the battle index page
      And I should see the button to add battles

    Scenario: Admin can remove battles
      Given I am an admin
      When I go to the battle index page
      Then I should be on the battle index page
      And I should see the button to remove 1st battle

    Scenario: Admin can edit battles
      Given I am an admin
      When I go to the battle index page
      Then I should be on the battle index page
      And I should see the button to edit 2nd battle

    Scenario: Users cannot access battle index
      When I go to the battle index page
      Then I should be on the home page
      And I should see "Access denied"

