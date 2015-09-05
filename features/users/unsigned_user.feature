Feature: Welcome page and access for unsigned users
  To allow an user to discover the website and get interested for it
  An unsigned user should have limited access to the right pages

Background: I am not a registered user and battles exist
    Given user "willywallace" exists
    And user "macewindu" exists
    And the following battles were added:
    | starts_at                 | duration  | user         | title     |
    | 2015-10-12 10:30:00 -0300 | 30000     | willywallace | battle 2  |
    | 2015-10-13 10:30:00 -0300 | 3000      | macewindu    | battle 3  |
    | 2015-10-20 10:30:00 -0300 | 3000      | willywallace | battle 5  |
    | 2015-10-22 10:30:00 -0300 | 4000      | macewindu    | battle 6  |
    And current time is 2015-10-21 07:28:00 -0300


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
