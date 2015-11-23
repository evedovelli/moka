Feature: Sign up
  In order to get access to protected sections of the site
  As an user
  I want to be able to sign up

Background:
    Given I am not logged in

    Scenario: User signs up with valid data
      When I sign up with valid user data
      Then I should be on the home page
      And I should see "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."

    Scenario: User signs up with invalid email
      When I sign up with an invalid email
      Then I should see an invalid email message

    Scenario: User signs up without username
      When I sign up without an username
      Then I should see a missing username message

    Scenario: User signs up with reserved username
      When I sign up with username "sign_in"
      Then I should see "Username is invalid"

    Scenario: User signs up with invalid username
      When I sign up with username "User.Name"
      Then I should see "Username is invalid. Only use letters, numbers and '_'"

    Scenario: User signs up without password
      When I sign up without a password
      Then I should see a missing password message

    Scenario: User signs up without password confirmation
      When I sign up without a password confirmation
      Then I should see a missing password confirmation message

    Scenario: User signs up with mismatched password and confirmation
      When I sign up with a mismatched password confirmation
      Then I should see a mismatched password message

