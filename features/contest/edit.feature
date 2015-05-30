Feature: Edit contest
  If an contest was created with a mistake
  An admin should be able to access the edit contest form

Background:
    Given I am logged in
    And I am an admin
    And the following contests were added:
    | starts_at                 | finishes_at               |
    | 2015-05-01 10:30:14 -0300 | 2015-05-14 10:30:15 -0300 |
    | 2015-05-22 10:30:14 -0300 | 2015-05-25 10:30:15 -0300 |
    | 2015-05-26 10:30:14 -0300 | 2015-05-29 10:30:15 -0300 |

    Scenario: Admin cannot see contest form unless he press the button to edit contest
      When I go to the contest index page
      Then I should not see the edit contest form for 1st contest

    @javascript
    Scenario: Admin can edit an contest from contest index page
      When I go to the contest index page
      And I press the button to edit 1st contest
      Then I should be on the contest index page
      And I should see the edit form for the 1st contest
      And I should see 2 contests

    @javascript
    Scenario: Cancelling new contest creation
      When I go to the contest index page
      And I press the button to edit 1st contest
      And I follow "Cancel"
      Then I should be on the contest index page
      And I should not see the edit contest form for 1st contest
      And I should see 3 contests


