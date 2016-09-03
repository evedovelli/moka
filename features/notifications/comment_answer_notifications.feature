Feature: Comment Notifications
  To instigate user to return sooner to the site
  Notifications should be sent when users comments to other users battles

Background: There is a battle running and users signed up
    Given I am logged in
    And user "dalek" exists
    And user "cyberman" exists
    And user "sontaran" exists
    And a battle was created with options "Doctor", "Rose" and "Mickey"
    And "dalek" logs in and comments "EXTERMINATE!" for "Rose"
    And "cyberman" logs in and comments "DELETE!" for "Rose"
    And "dalek" logs in and comments "NO, EXTERMINATE!" for "Rose"
    And "sontaran" logs in and comments "Sontar!" for "Mickey"
    And "sontaran" logs in and comments "Sontar -HA!" for "Rose"

    @javascript
    Scenario: User receives notification for answers for his comments in any battle
      When "dalek" logs in and goes to his home page
      Then he should see 2 notifications alert

    @javascript
    Scenario: User can see notification when someone comments in his battle
      When "dalek" logs in and goes to his home page
      And he clicks the notifications button
      Then he should see the notification "cyberman has answered to your comment." in dropdown menu
      Then he should see the notification "sontaran has answered to your comment." in dropdown menu
      And I should see option "Rose" in newest notification
