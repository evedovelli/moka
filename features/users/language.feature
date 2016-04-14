# encoding: UTF-8

Feature: Language selection
  To access the page in the language the user understands
  An user should be able to select is preferred language

Background: Website is operating

    Scenario: User changes from default language to another
      Given I am logged in
      And I am on my profile page
      When I go to the edit account page
      And I select "Português (Brasil)" from "user_language"
      And I fill in "Current password" with "secretpassword"
      And I click "Update"
      And I go to my profile page
      Then I should see "Adicionar batalha"

    Scenario: Visitor change language of cover page to Portuguese
      Given I am on the home page
      When I select language "Português (Brasil)"
      Then I should see "Crie suas batalhas"

    Scenario: Visitor change language of cover page to English
      Given I am on the home page
      When I select language "English"
      Then I should see "Battle everything"

    Scenario: Visitor change language of cover page to Portuguese and navigates to another page
      Given I am on the home page
      When I select language "Português (Brasil)"
      And I go to the terms of service page
      Then I should see "Termos de Serviço"

    Scenario: Visitor change language of cover page to English and navigates to another page
      Given I am on the home page
      When I select language "English"
      And I go to the terms of service page
      Then I should see "Terms of Service"
