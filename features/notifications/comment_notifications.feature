Feature: Comment Notifications
  To instigate user to return sooner to the site
  Notifications should be sent when users comments to other users battles

Background: There is a battle running and users signed up
    Given I am logged in
    And user "dalek" exists
    And a battle was created with options "Doctor", "Rose" and "Mickey"
    And "dalek" logs in and comments "EXTERMINATE!" for "Rose"

    @javascript
    Scenario: User receives notification alert when someone comments in his battle
      When I go to my home page
      Then I should see 1 notification alert

    @javascript
    Scenario: Notification alert disappears once user check the notifications
      When I go to my home page
      And I click the notifications button
      Then I should not see notification alert

    @javascript
    Scenario: User can see notification when someone comments in his battle
      When I go to my home page
      And I click the notifications button
      Then I should see the notification "dalek has commented in your battle." in dropdown menu
      And I should see option "Rose" in newest notification

    @javascript
    Scenario: User can see notification in notifications' page
      When I go to my notifications' page
      Then I should see the notification "dalek has commented in your battle."
      And I should see option "Rose" in newest notification
