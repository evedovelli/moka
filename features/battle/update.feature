Feature: Update battle
  If a battle was created with a mistake
  An admin should be able to fill and update an edit form for a battle

Background:
    Given I am logged in
    And I am an admin
    And the following battles were added:
    | starts_at                 | duration  | title            |
    | 2015-05-18 10:30:14 -0300 | 5760      | Choose anything  |
    And I am on the home page
    And I press the button to edit 1st battle

    @javascript
    Scenario: Update a battle
      When I fill in "battle_duration" with "300"
      And I press "Update"
      Then I should be on the home page
      And I should see "300 minutes"

    @javascript
    Scenario: Update a battle
      When I add 1st option "Vader" with picture "vader.jpg"
      And I press "Update"
      And I wait 4 seconds for uploading images
      Then I should be on the home page
      And I should see the image "vader.jpg"

    @javascript
    Scenario: Specify new battle title
      When I fill battle title with "Something something something Darkside?"
      And I press "Update"
      And I wait 4 seconds for uploading images
      Then I should be on the home page
      And I should see the battle title "Something something something Darkside?"

    @javascript
    Scenario: Specify new battle title
      When I fill battle title with ""
      And I press "Update"
      And I wait 4 seconds for uploading images
      Then I should be on the home page
      And I should see the battle title "Choose anything"

