Feature: Option quantities
  To improve visualization of options
  they should resize accordingly
  when user adds or remove options,
  when creating, showing or updating a battle

Background:
    Given I am logged in

    @javascript
    Scenario: User sees an error and big options when number of options is below 2 when creating battle
      When I go to the home page
      And I press the button to add new battle
      And I remove 2nd option
      Then I should see an error for the number of options
      And the size of option forms should be big
      And I should see a big offset for first option form

    @javascript
    Scenario: User can see big options with 2 options when creating battle
      When I go to the home page
      And I press the button to add new battle
      Then the size of option forms should be big
      And I should not see offset for first option form

    @javascript
    Scenario: User can see medium options with 3 options when creating battle
      When I go to the home page
      And I press the button to add new battle
      And I press the button to add option
      Then the size of option forms should be medium
      And I should not see offset for first option form

    @javascript
    Scenario: User can see small options with 4 options when creating battle
      When I go to the home page
      And I press the button to add new battle
      And I press the button to add option
      And I press the button to add option
      Then the size of option forms should be small
      And I should see a small offset for first option form

    @javascript
    Scenario: User can see small options with 5 options when creating battle
      When I go to the home page
      And I press the button to add new battle
      And I press the button to add option
      And I press the button to add option
      And I press the button to add option
      Then the size of option forms should be small
      And I should not see offset for first option form

    @javascript
    Scenario: User can see small options with 6 options when creating battle
      When I go to the home page
      And I press the button to add new battle
      And I press the button to add option
      And I press the button to add option
      And I press the button to add option
      And I press the button to add option
      Then the size of option forms should be small
      And I should not see offset for first option form
      And I should not see the button to add option

    @javascript
    Scenario: User can see again button to add option when removing 6th option in creation
      When I go to the home page
      And I press the button to add new battle
      And I press the button to add option
      And I press the button to add option
      And I press the button to add option
      And I press the button to add option
      And I remove 6th option
      Then the size of option forms should be small
      And I should not see offset for first option form
      And I should see the button to add option


    @javascript
    Scenario: User sees an error and big options when number of options is below 2 when updating battle
      Given the following battles were added:
      | starts_at                 | duration  | title            |
      | 2015-05-18 10:30:14 -0300 | 5760      | Choose anything  |
      And current time is 2015-05-18 12:28:00 -0300
      When I go to the home page
      And I press the button to edit 1st battle
      And I remove 2nd option
      Then I should see an error for the number of options
      And the size of option forms should be big
      And I should see a big offset for first option form

    @javascript
    Scenario: User can see big options with 2 options when updating battle
      Given the following battles were added:
      | starts_at                 | duration  | title            |
      | 2015-05-18 10:30:14 -0300 | 5760      | Choose anything  |
      And current time is 2015-05-18 12:28:00 -0300
      When I go to the home page
      And I press the button to edit 1st battle
      Then the size of option forms should be big
      And I should not see offset for first option form

    @javascript
    Scenario: User can see medium options with 3 options when updating battle
      Given the following battles were added:
      | starts_at                 | duration  | title            |
      | 2015-05-18 10:30:14 -0300 | 5760      | Choose anything  |
      And current time is 2015-05-18 12:28:00 -0300
      When I go to the home page
      And I press the button to edit 1st battle
      And I press the button to add option
      Then the size of option forms should be medium
      And I should not see offset for first option form

    @javascript
    Scenario: User can see small options with 4 options when updating battle
      Given the following battles were added:
      | starts_at                 | duration  | title            |
      | 2015-05-18 10:30:14 -0300 | 5760      | Choose anything  |
      And current time is 2015-05-18 12:28:00 -0300
      When I go to the home page
      And I press the button to edit 1st battle
      And I press the button to add option
      And I press the button to add option
      Then the size of option forms should be small
      And I should see a small offset for first option form

    @javascript
    Scenario: User can see small options with 5 options when updating battle
      Given the following battles were added:
      | starts_at                 | duration  | title            |
      | 2015-05-18 10:30:14 -0300 | 5760      | Choose anything  |
      And current time is 2015-05-18 12:28:00 -0300
      When I go to the home page
      And I press the button to edit 1st battle
      And I press the button to add option
      And I press the button to add option
      And I press the button to add option
      Then the size of option forms should be small
      And I should not see offset for first option form

    @javascript
    Scenario: User can see small options with 6 options when updating battle
      Given the following battles were added:
      | starts_at                 | duration  | title            |
      | 2015-05-18 10:30:14 -0300 | 5760      | Choose anything  |
      And current time is 2015-05-18 12:28:00 -0300
      When I go to the home page
      And I press the button to edit 1st battle
      And I press the button to add option
      And I press the button to add option
      And I press the button to add option
      And I press the button to add option
      Then the size of option forms should be small
      And I should not see offset for first option form
      And I should not see the button to add option

    @javascript
    Scenario: User can see again button to add option when removing 6th option when updating
      Given the following battles were added:
      | starts_at                 | duration  | title            |
      | 2015-05-18 10:30:14 -0300 | 5760      | Choose anything  |
      And current time is 2015-05-18 12:28:00 -0300
      When I go to the home page
      And I press the button to edit 1st battle
      And I press the button to add option
      And I press the button to add option
      And I press the button to add option
      And I press the button to add option
      And I remove 6th option
      Then the size of option forms should be small
      And I should not see offset for first option form
      And I should see the button to add option


    @javascript
    Scenario: User can see big options with 2 options
      Given a battle was created by "myself" with options:
      | name            | image                |
      | Devil Robot     | devil_robot.jpg      |
      | Dick Dastardly  | dick_dastardly.jpg   |
      When I go to the home page
      Then the size of options should be big
      And I should see a big offset for first option

    @javascript
    Scenario: User can see big options with 3 options
      Given a battle was created by "myself" with options:
      | name            | image                |
      | Devil Robot     | devil_robot.jpg      |
      | Dick Dastardly  | dick_dastardly.jpg   |
      | Palpatine       | palpatine.jpg        |
      When I go to the home page
      Then the size of options should be big
      And I should not see offset for first option

    @javascript
    Scenario: User can see medium options with 4 options
      Given a battle was created by "myself" with options:
      | name            | image                |
      | Devil Robot     | devil_robot.jpg      |
      | Dick Dastardly  | dick_dastardly.jpg   |
      | Palpatine       | palpatine.jpg        |
      | Vader           | vader.jpg            |
      When I go to the home page
      Then the size of options should be medium
      And I should not see offset for first option

    @javascript
    Scenario: User can see small options with 5 options
      Given a battle was created by "myself" with options:
      | name            | image                |
      | Devil Robot     | devil_robot.jpg      |
      | Dick Dastardly  | dick_dastardly.jpg   |
      | Palpatine       | palpatine.jpg        |
      | Vader           | vader.jpg            |
      | Robot Devil     | devil_robot.jpg      |
      When I go to the home page
      Then the size of options should be small
      And I should see a small offset for first option

    @javascript
    Scenario: User can see small options with 6 options
      Given a battle was created by "myself" with options:
      | name            | image                |
      | Devil Robot     | devil_robot.jpg      |
      | Dick Dastardly  | dick_dastardly.jpg   |
      | Palpatine       | palpatine.jpg        |
      | Vader           | vader.jpg            |
      | Robot Devil     | devil_robot.jpg      |
      | Vick Vigarista  | dick_dastardly.jpg   |
      When I go to the home page
      Then the size of options should be small
      And I should not see offset for first option

