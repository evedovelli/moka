Feature: Destroy
  If an user decides not use our services anymore
  or she does not aggree with our terms of service
  Then she should be able to cancel her account

Background: Two users and battles exist
    Given I exist as an user
    And user "captainjack" exists
    And the following battles were added:
    | starts_at                 | duration  | title            | user        |
    | 2015-06-20 10:30:11 -0300 | 5760      | My Battle        | myself      |
    | 2015-06-20 09:30:11 -0300 | 5760      | Tequila or Rum?  | captainjack |
    And current time is 2015-06-21 07:28:00 -0300
    And I am following "captainjack"

    @javascript
    Scenario: User cancels account and battles are not accessible anymore
      When user "captainjack" cancels his account
      And I sign in
      Then I should not see "Tequila or Rum"

    @javascript
    Scenario: User cancels account and votes disappear
      Given "captainjack" has voted for "Potato"
      When user "captainjack" cancels his account
      And I sign in
      Then I should see "Potato" with 0 votes

    @javascript
    Scenario: User cancels account and notifications disappear
      Given "captainjack" has logged in and voted for "Potato"
      When user "captainjack" cancels his account
      And I sign in
      And I go to my notifications' page
      Then I should be on my notifications' page
      And I should see 0 notifications
