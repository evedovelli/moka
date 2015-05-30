Feature: User's home page
  To allow an user visualize his details
  An user should be able to access and read the contents of his config page

Background: I am a registered user logged in
    Given I am logged in

    Scenario: User can see link to manage stuffs in config page
      When I go to the config page
      Then I should see "Stuffs"
      And "manage_stuffs" should link to the stuff index page

    Scenario: User can see link to manage contests in config page
      Given I am an admin
      When I go to the config page
      Then I should see "Contests"
      And "manage_contests" should link to the contest index page

