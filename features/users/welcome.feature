Feature: User's welcome message
  To help a new user to use the app
  A new user should be able to view a quick guide message

Background: I am a registered user logged in
    Given I am logged in
    And the following users exist:
    | username   | email            |
    | user1      | user1@user.com   |
    | user2      | user2@user.com   |
    | user3      | user3@user.com   |
    | user4      | user4@user.com   |
    | user5      | user5@user.com   |

    Scenario: Welcome message appears to just created users
      When I go to my home page
      Then I should see the welcome message

    @javascript
    Scenario: Welcome message may be closed
      When I go to my home page
      And I click to close the welcome message
      Then I should not see the welcome message

    Scenario: Welcome message is shown when following up to 4 users
      Given I am following 4 users
      When I go to my home page
      Then I should see the welcome message

    Scenario: Welcome message is not shown when following more than 4 users
      Given I am following 5 users
      When I go to my home page
      Then I should not see the welcome message
