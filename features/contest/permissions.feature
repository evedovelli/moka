Feature: Control of Access Permissions for Contests
  An user may have different permissions for accessing Contests
  depending on his roles

Background: I exist as an user and there are contests in database
    Given I am logged in
    And 2 contests were added

    Scenario: Admin can create contests
      Given I am an admin
      When I go to the contest index page
      Then I should be on the contest index page
      And I should see the button to add contests

    Scenario: Admin can remove contests
      Given I am an admin
      When I go to the contest index page
      Then I should be on the contest index page
      And I should see the button to remove 1st contest

    Scenario: Admin can edit contests
      Given I am an admin
      When I go to the contest index page
      Then I should be on the contest index page
      And I should see the button to edit 2nd contest

    Scenario: Users cannot access contest index
      When I go to the contest index page
      Then I should be on the home page
      And I should see "Access denied"

