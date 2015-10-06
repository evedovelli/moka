Feature: Vote Notifications
  To instigate user battles and notify users for them to reconnect sooner to the site
  Notifications should be sent when users vote to other users battles

Background: There is a battle running and users signed up
    Given I am logged in
    And user "dalek" exists
    And a battle was created with options "Doctor", "Rose" and "Mickey"
    And "dalek" logs in and votes for "Rose"

    @javascript
    Scenario: User receives notification alert when someone votes in his battle
      When I go to my home page
      Then I should see 1 notification alert

    @javascript
    Scenario: Notification alert disappears once user check the notifications
      When I go to my home page
      And I click the notifications button
      Then I should not see notification alert

    @javascript
    Scenario: User can see notification when someone votes in his battle
      When I go to my home page
      And I click the notifications button
      Then I should see the notification "dalek has voted in your battle." in dropdown menu
      And I should see option "Rose" selected for newest notification

    @javascript
    Scenario: User can see notification in notifications' page
      When I go to my notifications' page
      Then I should see the notification "dalek has voted in your battle."
      And I should see option "Rose" selected for newest notification

    @javascript
    Scenario: User receives only last notification within changes
      Given "dalek" logs in and votes for "Doctor"
      When I go to my home page
      And I click the notifications button
      Then I should see the notification "dalek has voted in your battle." in dropdown menu
      And I should see option "Doctor" selected for newest notification
      And I should see 1 notification

    @javascript
    Scenario: User receives only last notification in notifications' page within changes
      Given "dalek" logs in and votes for "Doctor"
      When I go to my notifications' page
      Then I should see the notification "dalek has voted in your battle."
      And I should see option "Doctor" selected for newest notification
      And I should see 1 notification

