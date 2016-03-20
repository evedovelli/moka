Feature: Edit User Navigations
  As a registered user of the website
  I want to navigate between multiple tags for editing my account
  so I can change different settings of my account organized by topics

Background: I exist as an user
    Given I am logged in

    Scenario: Go to the edit profile page
      Given I am on the edit account page
      When I follow "Profile picture"
      Then I should be on the edit profile picture page for "myself"

    Scenario: Go to the social settings page
      Given I am on the edit account page
      When I follow "Social"
      Then I should be on the social settings page

    Scenario: Go to the edit account page
      Given I am on the social settings page
      When I follow "Account"
      Then I should be on the edit account page

    Scenario: Go to the edit email settings page
      Given I am on the edit profile picture page for "myself"
      When I follow "Email settings"
      Then I should be on my email settings page
