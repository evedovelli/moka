Feature: Control of Access Permissions for Battles
  An user may have different permissions for accessing Battles
  depending on his roles

Background: I exist as an user and there are battles in database
    Given I am logged in
    And user "quino" exists
    And the following battles were added:
    | starts_at                 | duration  | user       | title    |
    | 2015-05-20 12:30:20 -0300 | 143999    | quino      | battle 1 |
    | 2015-05-18 10:30:14 -0300 | 143999    | myself     | battle 2 |
    | 2015-05-08 10:30:14 -0300 | 143999    | myself     | battle 3 |
    And current time is 2015-06-21 08:28:00 -0300

    @javascript
    Scenario: Admin can see button to remove any battle
      Given I am an admin
      And I am following "quino"
      When I go to my home page
      Then I should see the button to remove 1st battle
      And I should see the button to remove 2nd battle

    @javascript
    Scenario: Admin can remove any battle
      Given I am an admin
      And I am following "quino"
      When I go to my home page
      And I follow the link to remove 2nd battle
      And I confirm popup
      And I follow the link to remove 1st battle
      And I confirm popup
      Then I should not see the battle title "battle 2"
      And I should not see the battle title "battle 1"
      And I should see 1 battle

    @javascript
    Scenario: Normal user can see button to remove its battle
      Given I am following "quino"
      When I go to my home page
      Then I should not see the button to remove 1st battle
      And I should see the button to remove 2nd battle

    @javascript
    Scenario: Normal user can remove its battle
      Given I am following "quino"
      When I go to my home page
      And I follow the link to remove 2nd battle
      And I confirm popup
      Then I should not see the battle title "battle 2"
      And I should see 2 battles

    @javascript
    Scenario: Admin can see button to edit any battle
      Given I am an admin
      And I am following "quino"
      When I go to my home page
      Then I should see the button to edit 1st battle
      And I should see the button to edit 2nd battle

    @javascript
    Scenario: Admin can edit any battle
      Given I am an admin
      And I am following "quino"
      When I go to my home page
      And I press the button to edit 2nd battle
      And I fill battle title with "2nd battle"
      And I press "Update"
      And I wait 2 seconds
      And I press the button to edit 1st battle
      And I fill battle title with "1st battle"
      And I press "Update"
      Then I should see "2nd battle"
      Then I should see "1st battle"

    @javascript
    Scenario: Admin can edit finished battle
      Given I am an admin
      And I am following "quino"
      And current time is 2016-10-21 08:28:00 -0300
      When I go to my home page
      And I press the button to edit 1st battle
      And I fill battle title with "1st battle"
      And I press "Update"
      Then I should see "1st battle"

    @javascript
    Scenario: Normal user can see button to edit its battle
      Given I am following "quino"
      When I go to my home page
      Then I should not see the button to edit 1st battle
      And I should see the button to edit 2nd battle

    @javascript
    Scenario: Normal user can edit its battle
      Given I am following "quino"
      When I go to my home page
      And I press the button to edit 2nd battle
      And I fill battle title with "2nd battle"
      And I press "Update"
      Then I should see "2nd battle"

    @javascript
    Scenario: Normal user cannot edit finished battle
      Given I am following "quino"
      And current time is 2016-10-21 08:28:00 -0300
      When I go to my home page
      Then I should not see the button to edit 2nd battle


    Scenario: Admin can access his battles
      Given I am an admin
      When I go to the 1st battle page
      Then I should see "battle 1"

    Scenario: Admin can access others' battles
      Given I am an admin
      When I go to the 3rd battle page
      Then I should see "battle 3"

    Scenario: Admin can access removed battles
      Given I am an admin
      And battle 3 is removed
      When I go to the 3rd battle page
      Then I should see "battle 3"

    Scenario: Admin can access edit page for his battles
      Given I am an admin
      When I go to the 3rd battle edit page
      Then I should see the edit form for the 3rd battle

    Scenario: Admin can access edit page for others' battles
      Given I am an admin
      When I go to the 1st battle edit page
      Then I should see the edit form for the 1st battle

    Scenario: Admin can access edit page for finished battles
      Given current time is 2016-10-21 08:28:00 -0300
      And I am an admin
      When I go to the 2nd battle edit page
      Then I should see the edit form for the 2nd battle


    Scenario: Normal user can access his battles
      When I go to the 1st battle page
      Then I should see "battle 1"

    Scenario: Normal user can access others' battles
      When I go to the 3rd battle page
      Then I should see "battle 3"

    Scenario: Normal user cannot access removed battles
      Given battle 3 is removed
      When I go to the 3rd battle page
      Then I should see "Access denied"

    Scenario: Normal user can access edit page for his battles
      When I go to the 2nd battle edit page
      Then I should see the edit form for the 2nd battle

    Scenario: Normal user cannot access edit page for others' battles
      When I go to the 1st battle edit page
      Then I should see "Access denied"

    Scenario: Normal user cannot access edit page for finished battles
      Given current time is 2016-10-21 08:28:00 -0300
      When I go to the 2nd battle edit page
      Then I should see "Access denied"

