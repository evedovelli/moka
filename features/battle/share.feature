Feature: Share
  When an user wants his battle visible for all of his friends on Facebook
  He should be able to share the battle in Facebook
  So more people knows about Batalharia and subscribe to the website

Background:
    Given user "scott" exists
    And I am logged in
    And I accept to share my Facebook info:
    | email             | name            | picture      | verified  |
    | myself@email.com  | Myself Himself  | profile.jpg  | true      |
    And the following battles were added:
    | starts_at                 | duration  | title    | user    |
    | 2015-05-21 10:30:14 -0300 | 60        | battle 1 | myself  |
    | 2015-05-02 10:30:14 -0300 | 300       | battle 2 | scott   |
    And current time is 2015-05-28 10:31:14 -0300
    And I am following "scott"

    Scenario: User can share its battle
      When I go to the home page
      And I follow the link to share the 1st battle
      Then I should be on the "battle 1" battle page

    Scenario: User cannot share others' battles
      When I go to the home page
      Then I should not see a button to share the 2nd battle

