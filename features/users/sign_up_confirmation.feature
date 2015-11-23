Feature: Sign up Confirmation
  In order to confirm I am an user with valid email
  As an user
  I must confirm my inscription through the given email

Background:
    Given I am not logged in
    And no emails have been sent

    Scenario: User receives an email when signing up
      When I sign up with valid user data
      Then I should receive an email with subject "Confirmation instructions"
      And I should see "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."

    Scenario: User receives email with right content for sign up
      When I sign up with valid user data
      And I open the email
      Then I should see the email delivered from "Batalharia <noreply@batalharia.com>"
      And I should see "Welcome myself@email.com" in the email body
      And I should see "You can confirm your" in the email body
      And I should see "Batalharia" in the email body
      And I should see "account email through the link below" in the email body
      And I should see "Confirm my account" in the email body
      And I should see no attachments with the email

    Scenario: User sign up and try to login without email confirmation
      When I sign up with valid user data
      And I sign in
      Then I should be on the sign in page
      And I should see "You have to confirm your account before continuing."

    Scenario: User sign up, confirm and login
      When I sign up with valid user data
      And I open the email
      And I follow "Confirm my account" in the email
      And I sign in
      Then I should be on my home page

