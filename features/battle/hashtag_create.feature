Feature: Creates hashtags from Battle fields
  To allow users to increase visibility for his battles and
  to attract more users
  An user should be able to add searchable hashtags in battle
  titles and options names

Background:
    Given I am logged in
    And the following battles were added:
    | starts_at                 | duration  | title            |
    | 2015-06-20 10:30:14 -0300 | 5760      | Choose anything  |
    And current time is 2015-06-21 07:28:00 -0300
    And I am on the home page
    And I press the button to add new battle

    @javascript
    Scenario: Add hashtag in battle title
      When I fill battle title with "Who is the most awesome #starwars character?"
      And I add 1st option "Vader" with picture "vader.jpg"
      And I add 2nd option "Palpatine" with picture "palpatine.jpg"
      And I press "Create"
      And I go to the "starwars" hashtag page
      Then I should see 1 battle
      And I should see the battle title "Who is the most awesome #starwars character?"
      And I should not see the battle title "Choose anything"
      And "#starwars" within ".battle-title-row-container" should link to the "starwars" hashtag page

    @javascript
    Scenario: Add multiple hashtags in battle title
      When I fill battle title with "Who is the most awesome #starwars #character?"
      And I add 1st option "Vader" with picture "vader.jpg"
      And I add 2nd option "Palpatine" with picture "palpatine.jpg"
      And I press "Create"
      And I go to the "character" hashtag page
      Then I should see 1 battle
      And I should see the battle title "Who is the most awesome #starwars #character?"
      And I should not see the battle title "Choose anything"
      And "#starwars" within ".battle-title-row-container" should link to the "starwars" hashtag page
      And "#character" within ".battle-title-row-container" should link to the "character" hashtag page

    @javascript
    Scenario: Add hashtags in battle options
      When I fill battle title with "Who is the most awesome starwars character?"
      And I add 1st option "Darth #Vader" with picture "vader.jpg"
      And I add 2nd option "Emperor #Palpatine" with picture "palpatine.jpg"
      And I press "Create"
      And I go to the "palpatine" hashtag page
      Then I should see 1 battle
      And I should see the battle title "Who is the most awesome starwars character?"
      And I should not see the battle title "Choose anything"
      And "#Vader" within ".battle-box" should link to the "Vader" hashtag page
      And "#Palpatine" within ".battle-box" should link to the "Palpatine" hashtag page

