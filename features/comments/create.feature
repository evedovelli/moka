Feature: Create comment
  To give their opinions in other users' battles
  Users should be able to comment

Background: There is a battle running
    Given I am logged in
    And a battle was created with options "Devil", "Horror" and "Vader"

    @javascript
    Scenario: User comments to an option and see his comment
      Given user "Mickey" exists
      And "Mickey" has commented "Oh boy!" for "Horror"
      And I am on the home page
      When I comment "The force is strong with this One" for "Vader"
      Then I should see the newest comment "The force is strong with this One" for "Vader"

    @javascript
    Scenario: User comments to an option and see his comment in latest comments
      Given user "Mickey" exists
      And "Mickey" has commented "Oh boy!" for "Horror"
      And user "Goofy" exists
      And "Goofy" has commented "gawrsh!" for "Horror"
      And I am on the home page
      When I comment "OMG" for "Horror"
      And I go to the home page
      Then I should see "gawrsh!"
      And I should see "OMG"
      And I should not see "Oh boy!"

