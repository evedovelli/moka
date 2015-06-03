Feature: New vote
  To incentivate users to watch the show and interact with it
  Users should be able to vote in battles to eliminate
  the options they want to get out of the house

Background: The site is up and running
    Scenario: User can see a message when there is no battle running
      When I go to the home page
      Then I should see "There is no current battle :( Come back later!"

    Scenario: User can see a message when battle has not started yet
      Given the following battles were added:
      | starts_at                 | finishes_at               |
      | 2015-05-01 10:30:14 -0300 | 2015-05-14 10:30:15 -0300 |
      And current time is 2015-04-30 10:30:15 -0300
      When I go to the home page
      Then I should see "There is no current battle :( Come back later!"

    Scenario: User can see a message when battle is finished
      Given the following battles were added:
      | starts_at                 | finishes_at               |
      | 2015-05-01 10:30:14 -0300 | 2015-05-14 10:30:15 -0300 |
      And current time is 2015-06-03 10:30:15 -0300
      When I go to the home page
      Then I should see "There is no current battle :( Come back later!"

    Scenario: User can see battle when battle is created and running
      Given the following battles were added:
      | starts_at                 | finishes_at               |
      | 2015-05-01 10:30:14 -0300 | 2015-05-14 10:30:15 -0300 |
      And current time is 2015-05-01 10:30:15 -0300
      When I go to the home page
      Then I should see "Who should be evicted?"

    Scenario: User can only see options from battle in battle
      Given the following options were added:
      | name     | picture  |
      | Joseane  | 1        |
      | Arthur   | 2        |
      | Andréia  | 3        |
      And an battle was created with options "Joseane" and "Andréia"
      When I go to the home page
      Then I should see "Joseane"
      And I should see "Andréia"
      And I should not see "Arthur"

