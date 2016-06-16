Feature: Welcome page and access for unsigned users
  To allow an user to discover the website and get interested for it
  An unsigned user should have limited access to the right pages

Background: I am not a registered user and battles exist
    Given user "willywallace" exists
    And user "macewindu" exists
    And current time is 1985-10-21 07:28:00 -0300
    And a battle was created by "willywallace" with options:
    | name            | image              |
    | Devil_Robot     | devil_robot.jpg    |
    | Darth Vader     | vader.jpg          |
    And current time is 1985-10-21 08:28:00 -0300


    Scenario: I access the website home and I am redirected to the welcome page
      When I go to my home page
      Then I should be on the home page
      And I should see "Battle everything!"
      And I should see "Batalharia is a simple and fun way to create polls for everything and everywhere."
      And I should see "Whether you want to find out your best look, or who is the most powerful superhero, or yet, where to dinner tonight, or what will be your next reading, create your battles and find out which are the winners."
      And I should see "Share your battles on Facebook and invite your friends to vote and define who is gonna be victorious!"
      And I should see "Sign up now. It's free."

    Scenario: I access the sign up from the home page
      Given I am on the home page
      When I follow "Sign up"
      Then I should be on the sign up page

    Scenario: I access the sign in from the home page
      Given I am on the home page
      When I follow "Login"
      Then I should be on the sign in page

    @javascript
    Scenario: I try to vote and I am redirected to the login page
      Given I am on the "willywallace" profile page
      When I vote for "Darth Vader" for the 1st battle
      Then I should see the login form
      And I should not see any option selected

    @javascript
    Scenario: I try to vote and I close the login form
      Given I am on the "willywallace" profile page
      When I vote for "Darth Vader" for the 1st battle
      And I close the login window
      Then I should not see the login form
      And I should not see any option selected

    Scenario: I should see following of users
      Given "willywallace" is following "macewindu"
      When I go to the "willywallace" following page
      Then I should see "macewindu" in friendship list

    Scenario: I should see following of users
      Given "willywallace" is following "macewindu"
      When I go to the "macewindu" followers page
      Then I should see "willywallace" in friendship list

    @javascript
    Scenario: I can access a battle show page and try to vote
      Given I am on the 1st battle page
      When I vote for "Darth Vader"
      Then I should see the login form
      And I should not see any option selected

    @javascript
    Scenario: I try to follow user and I am redirected to the login page
      Given I am on the "willywallace" profile page
      When I click the "follow" button
      Then I should see the login form

    @javascript
    Scenario: I try to vote and I close the login form
      Given I am on the "willywallace" profile page
      When I click the "follow" button
      And I close the login window
      Then I should not see the login form

    @javascript
    Scenario: I try to see votes and I am redirected to the login page
      Given "Devil_Robot" has 5 votes
      And current time is 1995-10-21 08:28:00 -0300
      And I am on the "willywallace" profile page
      When I click to see voters for "Devil_Robot"
      Then I should see the login form

    @javascript
    Scenario: I try to vote and I close the login form
      Given "Devil_Robot" has 5 votes
      And current time is 1995-10-21 08:28:00 -0300
      And I am on the "willywallace" profile page
      When I click to see voters for "Devil_Robot"
      And I close the login window
      Then I should not see the login form

