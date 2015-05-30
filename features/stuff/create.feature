Feature: Create stuff
  To create stuffs whose participate of contests
  where users can elect which stuff should go home
  An admin should be able to fill and submit the new stuff form

Background:
    Given I am logged in
    And I am an admin
    And I am on the stuff index page
    And I press the button to add new stuff

    @javascript
    Scenario: Creation of a new stuff
      When I select picture number 2
      And I fill in "stuff_name" with "Joseane"
      And I press "Create"
      Then I should be on the stuff index page
      And I should see "Joseane"
      And I should see picture number 2 for "Joseane"

