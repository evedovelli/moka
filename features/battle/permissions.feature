Feature: Control of Access Permissions for Battles
  An user may have different permissions for accessing Battles
  depending on his roles

Background: I exist as an user and there are battles in database
    Given I am logged in
    And user "quino" exists
    And the following battles were added:
    | starts_at                 | duration  | user       |
    | 2015-05-20 12:30:20 -0300 | 8940      | quino      |
    | 2015-05-18 10:30:14 -0300 | 5760      | myself     |
    | 2015-05-08 10:30:14 -0300 | 5760      | myself     |

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
      Then I should see 1 battle

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
      Then I should see 2 battles

