Feature: Share
  When an user wants his battle visible for all of his friends on social networks
  He should be able to share the battle in Facebook
  So more people knows about Batalharia and subscribe to the website

Background:
    Given user "scott" exists
    And I am logged in
    And the following battles were added:
    | starts_at                 | duration  | title    | user    |
    | 2015-05-21 10:30:14 -0300 | 60        | battle 1 | myself  |
    | 2015-05-02 10:30:14 -0300 | 300       | battle 2 | scott   |
    And current time is 2015-05-28 10:31:14 -0300
    And I am following "scott"

    Scenario: User can share his battles on Facebook, Twitter and Google+
      When I go to the home page
      Then I should see buttons to share the 1st battle on Facebook, Twitter and Google+

    Scenario: User can share others' battles on Facebook, Twitter and Google+
      When I go to the home page
      Then I should see buttons to share the 2nd battle on Facebook, Twitter and Google+
