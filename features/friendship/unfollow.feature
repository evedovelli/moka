Feature: Unfollow
  To stop receiving battles from other users in his feed
  An user should be able to unfollow other user

Background: I am a registered user logged in and other users exist
    Given I am logged in
    And the following users exist:
    | username               | email                  |
    | omailey                | bomailey@mail.com      |
    | bradanderson           | banderson@gmail.com    |
    And I am following "omailey"
    And I am following "bradanderson"

    @javascript
    Scenario: I can unfollow user from his profile page
      Given I am on the "omailey" profile page
      When I click the "unfollow" button
      Then I should be on the "omailey" profile page
      And I should see a button to "follow"

    @javascript
    Scenario: I can unfollow user from any following page
      Given "omailey" is following "bradanderson"
      And I am on the "omailey" following page
      When I click the "unfollow" button for user "bradanderson"
      Then I should see "bradanderson" with button to "follow"

    @javascript
    Scenario: I can unfollow user from any followers page
      Given "bradanderson" is following "omailey"
      And I am on the "omailey" followers page
      When I click the "unfollow" button for user "bradanderson"
      Then I should see "bradanderson" with button to "follow"

