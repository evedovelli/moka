Feature: Index
  To consult created contests
  An user should be able to access the contest index

Background:
    Given I am logged in
    And I am an admin
    And I am on the configuration page

    Scenario: Admin can access contest index from config page
      Given 4 contests were added
      When I follow "manage_contests"
      Then I should be on the contest index page
      And I should see 4 contests

    Scenario: Admin return to config page when clicking back in template index
      When I follow "manage_contests"
      And I follow "Back"
      Then I should be on the configuration page

    Scenario: Admin can see link to statistics only for started contests
      Given the following contests were added:
      | starts_at                 | finishes_at               |
      | 2015-05-01 10:30:14 -0300 | 2015-05-14 10:30:15 -0300 |
      | 2015-05-22 10:30:14 -0300 | 2015-05-25 10:30:15 -0300 |
      | 2015-05-26 10:30:14 -0300 | 2015-05-29 10:30:15 -0300 |
      And current time is 2015-05-23 10:30:14 -0300
      When I go to the contest index page
      Then I should see statistics link for 1st contest
      And I should see statistics link for 2nd contest
      And I should not see statistics link for 3rd contest

