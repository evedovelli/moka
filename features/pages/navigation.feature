Feature: Pages Navigations
  As a visitor of the website
  I want to easily access the privacy policy, terms of use and other important pages
  so I can read them and decide whether or not to use the website

Background: I exist as an user

    Scenario: Go to the Privacy Policy page
      Given I am on the home page
      When I follow "Privacy Policy"
      Then I should be on the privacy policy page

    Scenario: Go to the Terms of Use page
      Given I am on the home page
      When I follow "Terms of Use"
      Then I should be on the terms of use page
