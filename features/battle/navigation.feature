Feature: Navigation
  An user should be able to access the page a single battle
  So she can easily copy the battle's URL and share anywhere

Background:
    Given user "scott" exists
    And I am logged in
    And the following battles were added:
    | starts_at                 | duration  | title    | user    |
    | 2015-05-21 10:30:14 -0300 | 60        | battle 1 | myself  |
    | 2015-05-02 10:30:14 -0300 | 300       | battle 2 | scott   |
    And current time is 2015-05-28 10:31:14 -0300
    And I am following "scott"

    Scenario: User can access battle page by clicking the title
      When I go to the home page
      And I follow "battle 1"
      Then I should be on the 1st battle page
