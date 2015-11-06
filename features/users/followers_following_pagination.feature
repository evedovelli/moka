Feature: Pagination of following and followes list
  To avoid slow load of following and followers list,
  these pages should be paginated
  The pages should have endless scroller to hide pagination
  from user and increase user experience

Background: I am a registered user logged in and other users exist
    Given I am logged in
    And the following users exist:
    | username   | email            |
    | user1      | user1@user.com   |
    | user2      | user2@user.com   |
    | user3      | user3@user.com   |
    | user4      | user4@user.com   |
    | user5      | user5@user.com   |
    | user6      | user6@user.com   |
    | user7      | user7@user.com   |
    | user8      | user8@user.com   |
    | user9      | user9@user.com   |
    | user10     | user10@user.com  |
    | user11     | user11@user.com  |
    | user12     | user12@user.com  |

    @javascript
    Scenario: Following list is paginated
      Given I am following the 12 users
      When I go to my following page
      Then I should be on my following page
      And I should find user "user1"
      And I should find user "user12"
      And I should find user "user7"
      And I should not find user "user8"

    @javascript
    Scenario: Following next page is loaded with endless scroller
      Given I am following the 12 users
      When I go to my following page
      And I scroll to the bottom of the page
      Then I should be on my following page
      And I should find user "user1"
      And I should find user "user12"
      And I should find user "user7"
      And I should find user "user8"
      And I should find user "user9"

    @javascript
    Scenario: Followers list is paginated
      Given the 12 users are following me
      When I go to my followers page
      Then I should be on my followers page
      And I should find user "user1"
      And I should find user "user12"
      And I should find user "user7"
      And I should not find user "user8"

    @javascript
    Scenario: Followers next page is loaded with endless scroller
      Given the 12 users are following me
      When I go to my followers page
      And I scroll to the bottom of the page
      Then I should be on my followers page
      And I should find user "user1"
      And I should find user "user12"
      And I should find user "user7"
      And I should find user "user8"
      And I should find user "user9"

