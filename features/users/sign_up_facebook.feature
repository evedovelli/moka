Feature: Sign up with Facebook
  To ease the sign up and sign in process
  As an user
  I want to be able to sign up using my Facebook account

Background:
    Given I am on the home page

    Scenario: Successful sign up with Facebook
      Given I accept to share my Facebook info:
      | email            | name                | picture      | verified  |
      | rebel@rebel.com  | Rebelious Reberant  | profile.jpg  | true      |
      When I click in the Sign in with Facebook button
      And I should see "rebel"
      And I go to the "rebel" profile page
      Then I should see "rebel" as my username
      And I should see "Rebelious Reberant" as my name

    Scenario: Sign in with Facebook
      Given I have signed up with my Facebook account
      And I am not signed in
      When I go to the home page
      And I click in the Sign in with Facebook button
      Then I should be on my home page

    Scenario: User does not share public profile
      Given I accept to share my Facebook info:
      | email            | verified  |
      | rebel@rebel.com  | true      |
      When I click in the Sign in with Facebook button
      And I go to the "rebel" profile page
      Then I should see "rebel" as my username

    Scenario: username is already taken
      Given the following users exist:
      | username   | email              |
      | rebel      | rudolph@mail.com   |
      And I accept to share my Facebook info:
      | email            | name                | picture      | verified  |
      | rebel@rebel.com  | Rebelious Reberant  | profile.jpg  | true      |
      When I click in the Sign in with Facebook button
      And I go to the "rebel1" profile page
      Then I should see "rebel1" as my username
      And I should see "Rebelious Reberant" as my name

    Scenario: Email is already signed up
      Given I exist as an user with:
      | username  | email             | name        | picture              |
      | myself    | myself@email.com  | Heisenberg  | profile_picture.jpg  |
      And I am not signed in
      And I accept to share my Facebook info:
      | email             | name          | picture      | verified  |
      | myself@email.com  | Walter White  | profile.jpg  | true      |
      When I click in the Sign in with Facebook button
      And I go to the social settings page
      Then I should see my Facebook account connected
      And I go to my profile page
      And I should see "Heisenberg" as my name

    Scenario: name is taken from Facebook
      Given I exist as an user
      And I am not signed in
      And I accept to share my Facebook info:
      | email             | name          | picture      | verified  |
      | myself@email.com  | Walter White  | profile.jpg  | true      |
      When I click in the Sign in with Facebook button
      And I go to the social settings page
      Then I should see my Facebook account connected
      And I go to my profile page
      And I should see "Walter White" as my name

    Scenario: connect Facebook account
      Given I am logged in
      And I am on the social settings page
      And I accept to share my Facebook info:
      | email             | name          | picture      | verified  |
      | myself@email.com  | Walter White  | profile.jpg  | true      |
      When I click to connect my Facebook account
      And I go to the social settings page
      Then I should see my Facebook account connected

    Scenario: Facebook's unconfirmed account
      Given no emails have been sent
      And I accept to share my Facebook info:
      | email            | name                | picture      | verified  |
      | rebel@rebel.com  | Rebelious Reberant  | profile.jpg  | false     |
      When I click in the Sign in with Facebook button
      Then "rebel@rebel.com" should receive an email with subject "Confirmation instructions"
      And I should see "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."

    Scenario: Confirming Facebook's unconfirmed account
      Given no emails have been sent
      And I accept to share my Facebook info:
      | email            | name                | picture      | verified  |
      | rebel@rebel.com  | Rebelious Reberant  | profile.jpg  | false     |
      When I click in the Sign in with Facebook button
      And "rebel@rebel.com" opens the email
      And "rebel@rebel.com" follows "Confirm my account" in the email
      And I click in the Sign in with Facebook button
      Then I should be on my home page
      And I should see "rebel"

