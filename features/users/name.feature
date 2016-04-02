Feature: Name
  To associate an user profile with the real owner
  An user should be able to inform his real name

Background: User exists and is logged in
    Given I am logged in
    And I am on my profile page

    Scenario: User adds a name to his profile
      When I go to the edit account page
      And I fill in "Name" with "Robert De Niro"
      And I fill in "Current password" with "secretpassword"
      And I click "Update"
      And I go to my profile page
      Then I should see "Robert De Niro" as my name

