Feature: Pagination Notifications
  To avoid slow charging of thousands of notifications
  Notifications should be paginated and loaded in small pieces

Background: There is a battle running and users signed up
    Given I am logged in
    And a battle was created with options "Doctor", "Rose" and "Mickey"
    And I have 36 notifications

    @javascript
    Scenario: User can see last notifications in dropdown menu
      When I go to my home page
      And I click the notifications button
      And I wait 1 second
      Then I should see the 6 last from 36 notifications

    @javascript
    Scenario: Notifications are paginated in notifications' page
      When I go to my home page
      And I click the notifications button
      And I click the all notifications button
      And I wait 1 second
      Then I should be on my notifications' page
      And I should see the 14 last from 36 notifications
      And I should see 15 notifications

    @javascript
    Scenario: Older notifications are loaded when scrolling the notifications' page
      When I go to my notifications' page
      And I scroll to the bottom of the page
      And I wait 1 second
      Then I should see 30 notifications

    @javascript
    Scenario: Older notifications are loaded when scrolling the notifications' page
      When I go to my notifications' page
      And I scroll to the bottom of the page
      And I wait 1 second
      And I scroll to the bottom of the page
      And I wait 1 second
      Then I should see 36 notifications

