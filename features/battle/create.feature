Feature: Create battle
  To allow users to vote between options to get out of the house
  An user should be able to fill and submit the new battle form

Background:
    Given I am logged in
    And I am on the home page
    And I press the button to add new battle
    And current time is 2015-06-21 07:28:00 -0300

    @javascript
    Scenario: Creation of a new battle
      When I add 1st option "Vader" with picture "vader.jpg"
      And I add 2nd option "Palpatine" with picture "palpatine.jpg"
      And I press "Create"
      Then I should see "Vader"
      And I should see the image "vader.jpg"
      And I should see "Palpatine"
      And I should see the image "palpatine.jpg"
      And I should see the battle ends in "2015/06/22 07:"
      And I should see the button to add new battle

    @javascript
    Scenario: Missing options
      When I add 1st option "Vader" with picture "vader.jpg"
      And I remove 2nd option
      And I press "Create"
      Then I should be on the home page
      And I should see an error for the number of options

    @javascript
    Scenario: Invalid duration fields
      When I add 1st option "Vader" with picture "vader.jpg"
      And I add 2nd option "Palpatine" with picture "palpatine.jpg"
      And I fill battle duration with 100 days, 23 hours and 59 mins
      And I should see error for days and no error for hours and mins
      And I fill battle duration with 100 days, 24 hours and 59 mins
      And I should see error for days and hours and no error for mins
      And I fill battle duration with 100 days, 24 hours and 60 mins
      And I press "Create"
      Then I should be on the home page
      And I should see error for days, hours and mins

    @javascript
    Scenario: Zeroed duration
      When I add 1st option "Vader" with picture "vader.jpg"
      And I add 2nd option "Palpatine" with picture "palpatine.jpg"
      And I fill battle duration with 0 days, 0 hours and 0 mins
      And I press "Create"
      Then I should be on the home page
      And I should see error for empty duration

    @javascript
    Scenario: Specify new battle title
      When I fill battle title with "Who is the most devil?"
      And I add 1st option "Vader" with picture "vader.jpg"
      And I add 2nd option "Palpatine" with picture "palpatine.jpg"
      And I press "Create"
      Then I should be on the home page
      And I should see the battle title "Who is the most devil?"
      And I should see "Vader"
      And I should see "Palpatine"

    @javascript
    Scenario: Creation of a new battle with default title
      When I add 1st option "Vader" with picture "vader.jpg"
      And I add 2nd option "Palpatine" with picture "palpatine.jpg"
      And I press "Create"
      Then I should be on the home page
      And I should see the battle title "Who should win this battle?"
      And I should see "Vader"
      And I should see "Palpatine"

    @javascript
    Scenario: Specify new battle with description
      When I fill battle description with "Chose the evilest Sith"
      And I add 1st option "Vader" with picture "vader.jpg"
      And I add 2nd option "Palpatine" with picture "palpatine.jpg"
      And I press "Create"
      Then I should be on the home page
      And I should see the battle title "Who should win this battle?"
      And I should see the battle description "Chose the evilest Sith"

    @javascript
    Scenario: Specify battle with too long content in text fields
      Given I click to close the welcome message
      When I fill battle title with "longlonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglongWWWWW"
      And I fill battle description with "greatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatKKKKK"
      And I add 1st option "bigbigbigbigbigbigbigbigbigbigbigbigbigbXX" with picture "vader.jpg"
      And I add 2nd option "Palpatine" with picture "palpatine.jpg"
      And I press "Create"
      Then I should be on the home page
      And I should see the battle title "longlonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglong"
      And I should see the battle description "greatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreatgreat"
      And I should see "bigbigbigbigbigbigbigbigbigbigbigbigbigb"
      And I should not see "W"
      And I should not see "K"
      And I should not see "X"
