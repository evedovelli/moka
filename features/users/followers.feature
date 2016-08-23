Feature: User's followers list
  To find an check battles from the followers of an user,
  An user should be able to check his and any user followers list

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
    Scenario: I can see users following me in my followers page
      Given "gotardo" is following "myself"
      And "omailey" is following "myself"
      When I click the "follow" button
      And I go to my followers page
      Then I should see "gotardo" with button to "follow"
      And I should see "omailey" with button to "unfollow"
      And I should not see "bradanderson"
      And I should not see "cirilo"

    @javascript
    Scenario: I can see users following another user in his followers page
      Given "gotardo" is following "omailey"
      And "cirilo" is following "omailey"
      And I am following "omailey"
      When I click the followers button
      Then I should be on the "omailey" followers page
      And I should see "gotardo" with button to "follow"
      And I should see "cirilo" with button to "follow"
      And I should see "myself" with button to "edit-profile"
      And I should not see "bradanderson"

    @javascript
    Scenario: I can access my followers page from my home page
      Given I am on my profile page
      When I click the followers button
      Then I should be on my followers page

