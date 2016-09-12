Feature: User's first battle guide message
  To incentive a new user to create battles
  The new user should see a message guiding her to add her first battle

Background: I am a registered user logged in
    Given I am logged in

    Scenario: First battle message appears to just created users
      When I go to my home page
      Then I should see a message to add my first battle

    @javascript
    Scenario: First battle message disappears when closed
      When I go to my home page
      And I click to close the first battle message
      Then I should not see a message to add my first battle

    @javascript
    Scenario: First battle message disappears when clicking to add battle
      When I go to my home page
      And I press the button to add new battle
      Then I should not see a message to add my first battle

    Scenario: First battle message is not shown when user has already created battles
      Given I have created a battle
      When I go to my home page
      Then I should not see a message to add my first battle
