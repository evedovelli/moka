Feature: Friendship Notifications
  To instigate user to follow more users and to let users to discover other users
  Notifications should be sent when users follow other users

Background: Users signed up
    Given I am logged in
    And user "dalek" exists
    And "dalek" logs in and follows me

    @javascript
    Scenario: User gets a notification alert when someone follows him
      When I go to my home page
      Then I should see 1 notification alert

    @javascript
    Scenario: Notification alert is erased when user sees notification
      When I go to my home page
      And I click the notifications button
      Then I should not see notification alert

    @javascript
    Scenario: User receives notification when someone follows him
      When I go to my home page
      And I click the notifications button
      Then I should see the notification "dalek is now following you." in dropdown menu

    @javascript
    Scenario: User can see notification in notifications' page
      When I go to my notifications' page
      Then I should see the notification "dalek is now following you."

    @javascript
    Scenario: User cannot see notification with user stops following
      Given "dalek" logs in and unfollows me
      When I go to my home page
      And I click the notifications button
      Then I should see 0 notifications

    @javascript
    Scenario: User receives only last notification in notifications' page within changes
      Given "dalek" logs in and unfollows me
      When I go to my notifications' page
      Then I should see 0 notifications

    @javascript
    Scenario: User can follow other user from notification message
      When I go to my home page
      And I click the notifications button
      When I click the "follow" button
      Then I should be on my home page
      And I should see a button to "unfollow"
