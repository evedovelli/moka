Feature: User's home page
  To allow an user visualize his details
  An user should be able to access and read the contents of his config page

Background: I am a registered user logged in
    Given I am logged in

    Scenario: User can see link to manage options in config page
      When I go to the config page
      Then I should see "Options"
      And "manage_options" should link to the option index page

    Scenario: User can see link to manage battles in config page
      Given I am an admin
      When I go to the config page
      Then I should see "Battles"
      And "manage_battles" should link to the battle index page

