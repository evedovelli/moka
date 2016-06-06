Feature: User is notified when is Facebook friend sign up
  To increase interation and time spent on the app
  A user may wants to follow all of his friends
  So when an user sign up to the app
  All of his Facebook friends on Batalharia
  should receive a notification about the sign up

Background: I exist as an user and have friends on Facebook
    Given I have signed up with my Facebook account
    And I should see "Logout"
    And I am not signed in
    And "Captain Fox" is friends with me on Facebook
    And the following users accept to share their Facebook info:
    | email         | name         | picture      | verified  | uid  |
    | fox@star.com  | Captain Fox  | profile.jpg  | true      | Fox  |

    Scenario: My Facebook friend signs up and I receive 1 notification
      When my Facebook friend "Captain Fox" signs up
      And I sign in with my Facebook account
      Then I should see 1 notification alert

    @javascript
    Scenario: My Facebook friend signs up and I receive the sign up notification
      When my Facebook friend "Captain Fox" signs up
      And I sign in with my Facebook account
      And I click the notifications button
      Then I should see the notification "Your Facebook friend Captain Fox just signed up" in dropdown menu

    Scenario: My Facebook friend signs up and I receive email notification
      Given no emails have been sent
      When my Facebook friend "Captain Fox" signs up
      And I wait 1 second
      Then I should receive an email with subject "Your Facebook friend Captain Fox has just signed up to Batalharia"

    Scenario: My Facebook friend signs up and I receive email with right contents
      Given no emails have been sent
      When my Facebook friend "Captain Fox" signs up
      And I wait 1 second
      And I open the email
      Then I should see the email delivered from "Batalharia <notification@batalharia.com>"
      And I should see it is a multi-part email
      And I should see "and don't miss any of" in the email html part body
      And I should see "battles on" in the email html part body
      And I should see "Visit Captain Fox profile" in the email html part body
      And I should see "Click on http://batalharia.com/en/users/fox to visit Captain Fox profile." in the email text part body
      And there should be an attachment named "logo_short.png"
      And attachment 1 should be of type "image/png"

    Scenario: I reach my Facebook friend profile through the received email
      Given no emails have been sent
      When my Facebook friend "Captain Fox" signs up
      And I wait 1 second
      And I open the email
      And I follow "http://batalharia.com/en/users/fox" in the email
      Then I should be on the "fox" profile page
