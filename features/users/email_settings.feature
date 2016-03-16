Feature: Email Settings
  To avoid spamming users' mailbox and to decrease the number of rejected email,
  The user should be able to select the categories of email she wants to receive

Background: Users signed up
    Given user "dalek" exists
    And I am logged in

    @javascript
    Scenario: User cancels email notification for new followers
      Given I am on my email settings page
      When I disable email reception for new followers
      And I update email settings
      And I should be on my profile page
      And no emails have been sent
      And "dalek" logs in and follows me
      Then I should receive no emails

    @javascript
    Scenario: User enables email notification for new followers
      Given I have disabled email reception for new followers
      And I am on the edit account page
      When I click to edit email settings
      And I enable email reception for new followers
      And I update email settings
      And I should be on my profile page
      And no emails have been sent
      And "dalek" logs in and follows me
      Then I should receive an email

