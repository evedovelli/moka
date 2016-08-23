Feature: User's following list
  To find an check battles from an user the user is following,
  or to find new users followed by someone with the same taste,
  An user should be able to check his and any user following list

Background: I am a registered user logged in and other users exist
    Given I am logged in
    And the following users exist:
    | username               | email                  |
    | gotardo                | gotardo@hotmail.com    |
    | cirilo                 | cirilo@gg.com          |
    | omailey                | bomailey@mail.com      |
    | bradanderson           | banderson@gmail.com    |
    And I am on the "omailey" profile page

    @javascript
    Scenario: I can see users I am following in my following page
      Given I am following "gotardo"
      And I am following "bradanderson"
      When I click the "follow" button
      And I go to my following page
      Then I should see "gotardo" with button to "unfollow"
      And I should see "bradanderson" with button to "unfollow"
      And I should see "omailey" with button to "unfollow"
      And I should not see "cirilo"

    @javascript
    Scenario: I can see users another user is following in his following page
      Given "omailey" is following "gotardo"
      And "omailey" is following "cirilo"
      And "omailey" is following "myself"
      And I am following "gotardo"
      When I click the following button
      Then I should be on the "omailey" following page
      And I should see "gotardo" with button to "unfollow"
      And I should see "cirilo" with button to "follow"
      And I should see "myself" with button to "edit-profile"
      And I should not see "bradanderson"

    @javascript
    Scenario: I can access my following page from my home page
      Given I am on my profile page
      When I click the following button
      Then I should be on my following page

