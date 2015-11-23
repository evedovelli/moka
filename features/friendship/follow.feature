Feature: Follow
  To receive battles from other users in his feed
  An user should be able to follow other user

Background: I am a registered user logged in and other users exist
    Given I am logged in
    And the following users exist:
    | username               | email                  |
    | omailey                | bomailey@mail.com      |
    | bradanderson           | banderson@gmail.com    |

    @javascript
    Scenario: I can follow user from his profile page
      Given I am on the "omailey" profile page
      When I click the "follow" button
      Then I should be on the "omailey" profile page
      And I should see a button to "unfollow"

    @javascript
    Scenario: I can follow user from any following page
      Given "omailey" is following "bradanderson"
      And I am on the "omailey" following page
      When I click the "follow" button for user "bradanderson"
      Then I should see "bradanderson" with button to "unfollow"

    @javascript
    Scenario: I can follow user from any followers page
      Given "bradanderson" is following "omailey"
      And I am on the "omailey" followers page
      When I click the "follow" button for user "bradanderson"
      Then I should see "bradanderson" with button to "unfollow"

    @javascript
    Scenario: Followed user is notified by email
      Given no emails have been sent
      And I am on the "omailey" profile page
      When I click the "follow" button
      And I wait 1 seconds
      Then "bomailey@mail.com" should receive an email with subject "myself is now following you on Batalharia"

    @javascript
    Scenario: Followed user email notification should have the right contents
      Given no emails have been sent
      And I am on the "omailey" profile page
      When I click the "follow" button
      And I wait 1 seconds
      And "bomailey@mail.com" opens the email
      Then I should see the email delivered from "Batalharia <notification@batalharia.com>"
      And I should see it is a multi-part email
      And I should see "is now following you on" in the email html part body
      And I should see "Batalharia" in the email html part body
      And I should see "Visit myself profile" in the email html part body
      And I should see "myself is now following you on Batalharia" in the email text part body
      And I should see "Click on http://batalharia.com/en/users/myself to visit myself profile." in the email text part body
      And there should be an attachment named "logo_short.png"
      And attachment 1 should be of type "image/png"

    @javascript
    Scenario: Followed user reaches site by email notification
      Given no emails have been sent
      And I am on the "omailey" profile page
      When I click the "follow" button
      And I wait 1 seconds
      And "bomailey@mail.com" opens the email
      And I click the first link in the email
      Then I should be on the home page

    @javascript
    Scenario: Followed user reaches follower page by email notification
      Given no emails have been sent
      And I am on the "omailey" profile page
      When I click the "follow" button
      And I go to the home page
      And I wait 1 seconds
      And "bomailey@mail.com" opens the email
      And "bomailey@mail.com" follows "Visit myself profile" in the email
      Then I should be on my profile page

