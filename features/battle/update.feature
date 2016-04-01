Feature: Update battle
  If a battle was created with a mistake
  An admin should be able to fill and update an edit form for a battle

Background:
    Given I am logged in
    And the following battles were added:
    | starts_at                 | duration  | title            |
    | 2015-05-18 10:30:14 -0300 | 5760      | Choose anything  |
    And current time is 2015-05-18 10:31:14 -0300
    And I am on the home page
    And I press the button to edit 1st battle

    @javascript
    Scenario: Update a battle
      When I fill battle duration with 0 days, 5 hours and 0 mins
      And I press "Update"
      Then I should be on the home page
      And I should see the battle ends in "2015/05/18 15:30:14"

    @javascript
    Scenario: Update a battle
      When I add 1st option "Vader" with picture "vader.jpg"
      And I press "Update"
      Then I should be on the home page
      And I should see the image "vader.jpg"

    @javascript
    Scenario: Specify new battle title
      When I fill battle title with "Something something something Darkside?"
      And I press "Update"
      Then I should be on the home page
      And I should see the battle title "Something something something Darkside?"

    @javascript
    Scenario: Specify new battle title
      When I fill battle title with ""
      And I press "Update"
      Then I should be on the home page
      And I should see the battle title "Choose anything"

    @javascript
    Scenario: Specify new battle with description
      When I fill battle description with "Chose the evilest Sith"
      And I press "Update"
      Then I should be on the home page
      And I should see the battle description "Chose the evilest Sith"

    @javascript
    Scenario: Specify battle with too long content in text fields
      When I fill battle title with "longlonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglongWWWWW"
      And I fill battle description with "greatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatKKKKK"
      And I fill 1st option with "bigbigbigbigbigbigbigbigbigbigbigbigbigbXX"
      And I press "Update"
      Then I should be on the home page
      And I should see the battle title "longlonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglong"
      And I should see the battle description "greatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreat"
      And I should see "bigbigbigbigbigbigbigbigbigbigbigbigbigb"
      And I should not see "W"
      And I should not see "K"
      And I should not see "X"

    @javascript
    Scenario: Invalid duration fields
      When I fill battle duration with 100 days, 23 hours and 59 mins
      And I should see error for days and no error for hours and mins
      And I fill battle duration with 100 days, 24 hours and 59 mins
      And I should see error for days and hours and no error for mins
      And I fill battle duration with 100 days, 24 hours and 60 mins
      And I press "Update"
      Then I should be on the home page
      And I should see error for days, hours and mins

    @javascript
    Scenario: Zeroed duration
      When I fill battle duration with 0 days, 0 hours and 0 mins
      And I press "Update"
      Then I should be on the home page
      And I should see error for empty duration
