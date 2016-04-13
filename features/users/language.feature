# encoding: UTF-8

Feature: Language selection
  To access the page in the language the user understands
  An user should be able to select is preferred language

Background: User exists and is logged in
    Given I am logged in
    And I am on my profile page

    Scenario: User changes from default language to another
      When I go to the edit account page
      And I select "Português (Brasil)" from "user_language"
      And I fill in "Current password" with "secretpassword"
      And I click "Update"
      And I go to my profile page
      Then I should see "Adicionar batalha"

