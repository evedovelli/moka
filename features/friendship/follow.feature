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

