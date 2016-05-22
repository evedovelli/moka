Feature: User's facebook friends list
  To find users to follow on Batalharia
  So I can see many battles on my feed
  An user should be able to find a list of his
  Facebook friends who are Batalharia users

Background: App is running

    Scenario: I cannot see button to find Facebook friends when I am not logged in
      Given the following users exist:
      | username   | email                   |
      | bubblegum  | princess@bubblegum.com  |
      When I go to the "bubblegum" following page
      Then I should not see the button to find friends from Facebook

    Scenario: I am redirected to home page when trying to find Facebook friends not logged in
      Given I accept to share my Facebook info:
      | email            | name                | picture      | verified  |
      | rebel@rebel.com  | Rebelious Reberant  | profile.jpg  | true      |
      When I go to the find Facebook friends page
      Then I should be on the home page
      And I should see "You must sign in before searching friends on Facebook"

    Scenario: I am redirected to sign in page when trying to acces Facebook friends list not logged in
      When I go to the Facebook friends page
      Then I should be on the sign in page
      And I should see "You need to sign in or sign up before continuing"

    Scenario: I can search Facebook friends from users following page
      Given I am logged in
      And the following users exist:
      | username   | email                   |
      | bubblegum  | princess@bubblegum.com  |
      When I go to the "bubblegum" following page
      Then I should see the button to find friends from Facebook

    Scenario: I can search Facebook friends from users followers page
      Given I am logged in
      And the following users exist:
      | username   | email                   |
      | bubblegum  | princess@bubblegum.com  |
      When I go to the "bubblegum" followers page
      Then I should see the button to find friends from Facebook

    Scenario: I can search Facebook friends from social settings page
      Given I am logged in
      When I go to the social settings page
      Then I should see the button to find friends from Facebook

    @javascript
    Scenario: I can search Facebook friends from my empty home page
      Given I am logged in
      When I go to my home page
      Then I should see the button to find friends from Facebook

    @javascript
    Scenario: I can not search Facebook friends from my full home page
      Given I am logged in
      And the following battles were added:
      | starts_at                 | duration  | user     | title        |
      | 2015-10-01 10:30:00 -0300 | 6000      | myself   | first battle |
      | 2015-10-02 10:30:00 -0300 | 30000     | myself   | battle 2     |
      | 2015-10-03 10:30:00 -0300 | 58000     | myself   | battle 3     |
      | 2015-10-04 10:30:00 -0300 | 3000      | myself   | battle 4     |
      | 2015-10-04 11:30:00 -0300 | 3000      | myself   | battle 5     |
      | 2015-10-05 10:30:00 -0300 | 6000      | myself   | battle 6     |
      When I go to my home page
      Then I should not see the button to find friends from Facebook

    @javascript
    Scenario: I can search Facebook friends from the end of my home page
      Given I am logged in
      And the following battles were added:
      | starts_at                 | duration  | user     | title        |
      | 2015-10-01 10:30:00 -0300 | 6000      | myself   | first battle |
      | 2015-10-02 10:30:00 -0300 | 30000     | myself   | battle 2     |
      | 2015-10-03 10:30:00 -0300 | 58000     | myself   | battle 3     |
      | 2015-10-04 10:30:00 -0300 | 3000      | myself   | battle 4     |
      | 2015-10-04 11:30:00 -0300 | 3000      | myself   | battle 5     |
      | 2015-10-05 10:30:00 -0300 | 6000      | myself   | battle 6     |
      When I go to my home page
      And I scroll to the bottom of the page
      Then I should see the button to find friends from Facebook

    Scenario: I can see all the Facebook friends I am not following in my Facebook friends list
      Given I accept to share my Facebook info:
      | email            | name                | picture      | verified  |
      | rebel@rebel.com  | Rebelious Reberant  | profile.jpg  | true      |
      And user "octopus" with Facebook's account exists
      And user "shark" with Facebook's account exists
      And I am logged in
      And I am following "shark"
      And I am friends with "octopus" on Facebook
      And I am friends with "shark" on Facebook
      When I go to my home page
      And I click to find friends from Facebook
      Then I should see "octopus"
      And I should not see "shark"
      And I should be on the Facebook friends page

    @javascript
    Scenario: I follow a friend and he is removed from my Facebook friends list
      Given I accept to share my Facebook info:
      | email            | name                | picture      | verified  |
      | rebel@rebel.com  | Rebelious Reberant  | profile.jpg  | true      |
      And user "octopus" with Facebook's account exists
      And I am logged in
      And I am friends with "octopus" on Facebook
      When I go to the "octopus" followers page
      And I click to find friends from Facebook
      And I go to the "octopus" profile page
      And I click the "follow" button
      And I go to the "octopus" followers page
      And I click to find friends from Facebook
      Then I should not see "octopus"
      And I should be on the Facebook friends page

    Scenario: I add friend on Facebook and update my Facebook list
      Given I accept to share my Facebook info:
      | email            | name                | picture      | verified  |
      | rebel@rebel.com  | Rebelious Reberant  | profile.jpg  | true      |
      And user "octopus" with Facebook's account exists
      And user "shark" with Facebook's account exists
      And I am logged in
      And I am friends with "octopus" on Facebook
      When I go to my home page
      And I click to find friends from Facebook
      And I become friends with "shark" on Facebook
      And I click to update friends from Facebook
      Then I should see "shark"
      And I should see "octopus"
      And I should be on the Facebook friends page
