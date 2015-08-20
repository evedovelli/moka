Feature: Destroy
  When an user has created a battle with errors
  He should be able to destroy the battle

Background:
    Given I am logged in
    And the following battles were added:
    | starts_at                 | duration  | title    |
    | 2015-05-01 10:30:14 -0300 | 60        | battle 1 |
    | 2015-05-22 10:30:14 -0300 | 300       | battle 2 |
    | 2015-05-26 10:30:14 -0300 | 580       | battle 3 |
    And current time is 2015-05-28 10:31:14 -0300
    And I am on the home page

    @javascript
    Scenario: User can destroy battle
      When I follow the link to remove 1st battle
      And I confirm popup
      And I wait 2 seconds
      Then I should be on the home page
      And I should see 2 battles
      And I should not see the battle title "battle 1"

    @javascript
    Scenario: User can cancel destruction of battle
      When I follow the link to remove 1st battle
      And I dismiss popup
      Then I should be on the home page
      And I should see 3 battles

    @javascript
    Scenario: User destroy battle and reload page
      When I follow the link to remove 1st battle
      And I confirm popup
      And I go to my home page
      Then I should see 2 battles
      And I should not see the battle title "battle 1"

