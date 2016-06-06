Feature: Email Settings
  To avoid spamming users' mailbox and to decrease the number of rejected email,
  The user should be able to select the categories of email she wants to receive

Background: Users signed up

    @javascript
    Scenario: User cancels email notification for new followers
      Given user "dalek" exists
      And I am logged in
      And I am on my email settings page
      When I disable email reception for new followers
      And I update email settings
      And I should be on my profile page
      And no emails have been sent
      And "dalek" logs in and follows me
      Then I should receive no emails

    @javascript
    Scenario: User enables email notification for new followers
      Given user "dalek" exists
      And I am logged in
      And I have disabled email reception for new followers
      And I am on the edit account page
      When I click to edit email settings
      And I enable email reception for new followers
      And I update email settings
      And I should be on my profile page
      And no emails have been sent
      And "dalek" logs in and follows me
      Then I should receive an email

    Scenario: User cancels email notification for new Facebook friends
      Given I have signed up with my Facebook account
      And "Captain Fox" is friends with me on Facebook
      And the following users accept to share their Facebook info:
      | email         | name         | picture      | verified  | uid  |
      | fox@star.com  | Captain Fox  | profile.jpg  | true      | Fox  |
      And I am on my email settings page
      When I disable email reception for new Facebook friends
      And I update email settings
      And I should be on my profile page
      And no emails have been sent
      And I sign out
      And my Facebook friend "Captain Fox" signs up
      Then I should receive no emails

    Scenario: User enables email notification for new Facebook friends
      Given I have signed up with my Facebook account
      And "Captain Fox" is friends with me on Facebook
      And the following users accept to share their Facebook info:
      | email         | name         | picture      | verified  | uid  |
      | fox@star.com  | Captain Fox  | profile.jpg  | true      | Fox  |
      And I am on my email settings page
      When I enable email reception for new followers
      And I update email settings
      And I should be on my profile page
      And no emails have been sent
      And I sign out
      And my Facebook friend "Captain Fox" signs up
      Then I should receive an email
