Feature: User's search
  To allow an user to find his friends and other interisting
  users to follow
  An user should be able to search for users

Background: There are many users in database
    Given the following users exist:
    | username   | email            | name     |
    | user1      | user1@user.com   | u_Word   |
    | user2      | user2@user.com   | u_wOrd   |
    | user3      | user3@user.com   | u_woRd   |
    | user4      | user4@user.com   | u_worD   |
    | user5      | user5@user.com   | u_word   |
    | test1      | test1@user.com   | t_Word   |
    | test2      | test2@user.com   | t_wOrd   |
    | test3      | test3@user.com   | t_woRd   |
    | test4      | test4@user.com   | t_worD   |
    | test5      | test5@user.com   | name     |
    | user6      | user6@user.com   | test     |
    | user7      | user7@user.com   | test     |
    | user8      | user8@user.com   | test     |
    | user9      | user9@user.com   | name     |
    | user10     | user10@user.com  | single   |
    | user11     | user11@user.com  | name     |
    | user12     | user12@user.com  | name     |

    Scenario: I find user by username
      Given I am on the "user1" profile page
      When I search for user with "user8"
      Then I should be on the user index page
      And I should find user "user8"
      And I should not find user "user1"

    Scenario: I find user by name
      Given I am on the "user1" profile page
      When I search for user with "single"
      Then I should be on the user index page
      And I should find user "user10"
      And I should not find user "user8"

    Scenario: I find user by name and username
      Given I am on the "user1" profile page
      When I search for user with "test"
      Then I should be on the user index page
      And I should find user "test1"
      And I should find user "test2"
      And I should find user "test3"
      And I should find user "test4"
      And I should find user "test5"
      And I should find user "user6"
      And I should find user "user7"
      And I should find user "user8"
      And I should not find user "user5"
      And I should not find user "user9"

    Scenario: I find user despite the case and the point of start of string
      Given I am on the "user1" profile page
      When I search for user with "WORD"
      Then I should be on the user index page
      And I should find user "user1"
      And I should find user "user2"
      And I should find user "user3"
      And I should find user "user4"
      And I should find user "user5"
      And I should find user "test1"
      And I should find user "test2"
      And I should find user "test3"
      And I should find user "test4"
      And I should not find user "test5"

    Scenario: User search results are paginated
      Given I am on the "user1" profile page
      When I search for user with "user"
      Then I should be on the user index page
      And I should find user "user1"
      And I should find user "user5"
      And I should find user "user10"
      And I should not find user "user11"

    @javascript
    Scenario: User search results have infinit scrolling
      Given I am on the "user1" profile page
      When I search for user with "user"
      And I scroll to the bottom of the page
      Then I should be on the user index page
      And I should find user "user1"
      And I should find user "user5"
      And I should find user "user10"
      And I should find user "user11"
      And I should find user "user12"
      And I should not find user "test1"

    Scenario: User search without search word
      Given I am on the "user1" profile page
      When I search for user with ""
      Then I should be on the home page

