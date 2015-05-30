Feature: New vote
  To incentivate users to watch the show and interact with it
  Users should be able to vote in contests to eliminate
  the stuffs they want to get out of the house

Background: The site is up and running
    Scenario: User can see a message when there is no contest running
      When I go to the home page
      Then I should see "There is no current contest :( Come back later!"

    Scenario: User can see a message when contest has not started yet
      Given the following contests were added:
      | starts_at                 | finishes_at               |
      | 2015-05-01 10:30:14 -0300 | 2015-05-14 10:30:15 -0300 |
      And current time is 2015-04-30 10:30:15 -0300
      When I go to the home page
      Then I should see "There is no current contest :( Come back later!"

    Scenario: User can see a message when contest is finished
      Given the following contests were added:
      | starts_at                 | finishes_at               |
      | 2015-05-01 10:30:14 -0300 | 2015-05-14 10:30:15 -0300 |
      And current time is 2015-06-03 10:30:15 -0300
      When I go to the home page
      Then I should see "There is no current contest :( Come back later!"

    Scenario: User can see contest when contest is created and running
      Given the following contests were added:
      | starts_at                 | finishes_at               |
      | 2015-05-01 10:30:14 -0300 | 2015-05-14 10:30:15 -0300 |
      And current time is 2015-05-01 10:30:15 -0300
      When I go to the home page
      Then I should see "Who should be evicted?"

    Scenario: User can only see stuffs from contest in contest
      Given the following stuffs were added:
      | name     | picture  |
      | Joseane  | 1        |
      | Arthur   | 2        |
      | Andréia  | 3        |
      And an contest was created with stuffs "Joseane" and "Andréia"
      When I go to the home page
      Then I should see "Joseane"
      And I should see "Andréia"
      And I should not see "Arthur"

