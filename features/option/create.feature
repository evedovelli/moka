Feature: Create option
  To create options whose participate of battles
  where users can elect which option should go home
  An admin should be able to fill and submit the new option form

Background:
    Given I am logged in
    And I am an admin
    And I am on the option index page
    And I press the button to add new option

    @javascript
    Scenario: Creation of a new option
      When I select picture number 2
      And I fill in "option_name" with "Joseane"
      And I press "Create"
      Then I should be on the option index page
      And I should see "Joseane"
      And I should see picture number 2 for "Joseane"

