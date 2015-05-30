Feature: Edit User
  As a registered user of the website
  I want to edit my user profile
  so I can change my username

Background: I exist as an user
    Given I am logged in

    Scenario: I sign in and edit my account
      When I edit my account details
      Then I should see an account edited message

    Scenario: I sign in and change my username and log in with new username
      When I edit my username with "lord"
      And I sign out
      And I sign in with "lord"
      Then I see a successful sign in message

    Scenario: I sign in and change my username and fail to log in with old username
      When I edit my username with "lord"
      And I sign out
      And I sign in with username
      Then I see an invalid login message

    Scenario: I sign in and change my email and log in with new email
      When I edit my email with "lord@email.com"
      And I sign out
      And I sign in with "lord@email.com"
      Then I see a successful sign in message

    Scenario: I sign in and change my email and fail to log in with old email
      When I edit my email with "lord@email.com"
      And I sign out
      And I sign in with valid credentials
      Then I see an invalid login message

    Scenario: I sign in and change my password and log in with new password
      When I edit my password with "unknown"
      And I sign out
      And I sign in with password "unknown"
      Then I see a successful sign in message

    Scenario: I sign in and change my password and fail to log in with old password
      When I edit my password with "unknown"
      And I sign out
      And I sign in
      Then I see an invalid login message

