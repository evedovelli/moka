Feature: Profile picture
  To be easily identified across the network
  An user should be able to add a profile picture identifying himself

Background: User exists and is logged in
    Given I am logged in

    Scenario: User should see default picture in profile when no picture was uploaded
      When I go to my profile page
      Then I should see the default profile picture for profile

    Scenario: User should see default picture in battles when no picture was uploaded
      Given a battle was created with images "palpatine.jpg" and "devil_robot.jpg"
      When I go to my profile page
      Then I should see the default profile picture for 1st battle

    Scenario: User should see default picture in friendship lists when no picture was uploaded
      Given the following users exist:
      | username               | email                  |
      | omailey                | bomailey@mail.com      |
      And "omailey" is following "myself"
      And I go to the the "omailey" following page
      Then I should see the default profile picture for "myself"

    @javascript
    Scenario: User can see preview when uploading profile picture
      When I go to my profile page
      And I click to edit my profile picture
      And I wait 1 second
      And I select "wario.png" image for my profile picture
      Then I should see the preview of the image for my profile picture

    @javascript
    Scenario: User sees previous picture after removing profile picture preview
      Given I have uploaded the "wario.png" image as my profile picture
      When I go to my profile page
      And I click to edit my profile picture
      And I wait 1 second
      And I select "vader.jpg" image for my profile picture
      And I remove the profile picture uploaded image
      Then I should see the preview with the current "wario.png" image

    @javascript
    Scenario: User can update his profile picture
      When I go to my profile page
      And I click to edit my profile picture
      And I wait 1 second
      And I select "wario.png" image for my profile picture
      And I click "Update"
      Then I should be on my profile page
      And I should see the "wario.png" profile picture for profile

    Scenario: User should see his profile picture in his profile
      Given I have uploaded the "wario.png" image as my profile picture
      When I go to my profile page
      Then I should see the "wario.png" profile picture for profile

    Scenario: User should see his profile picture in his battles
      Given a battle was created with images "palpatine.jpg" and "devil_robot.jpg"
      And I have uploaded the "wario.png" image as my profile picture
      When I go to my profile page
      Then I should see the "wario.png" profile picture for 1st battle

    Scenario: User should see his profile picture in friendship lists
      Given the following users exist:
      | username               | email                  |
      | omailey                | bomailey@mail.com      |
      And I have uploaded the "wario.png" image as my profile picture
      And "omailey" is following "myself"
      And I go to the the "omailey" following page
      Then I should see the "wario.png" profile picture for "myself"


    Scenario: User should see default picture in profile when no picture was uploaded
      When I go to the edit profile picture page for "myself"
      Then I should see the default profile picture for profile

    @javascript
    Scenario: User can see preview when uploading profile picture from edit profile picture page
      When I go to the edit profile picture page for "myself"
      And I select "wario.png" image for my profile picture
      Then I should see the preview of the image for my profile picture

    @javascript
    Scenario: User sees previous picture after removing profile picture preview from edit profile picture page
      Given I have uploaded the "wario.png" image as my profile picture
      When I go to the edit profile picture page for "myself"
      And I select "vader.jpg" image for my profile picture
      And I remove the profile picture uploaded image
      Then I should see the preview with the current "wario.png" image

    @javascript
    Scenario: User can update his profile picture from edit profile picture page
      When I go to the edit profile picture page for "myself"
      And I select "wario.png" image for my profile picture
      And I click "Update"
      And I go to my profile page
      Then I should see the "wario.png" profile picture for profile

    Scenario: User should see his profile picture in his profile from edit profile picture page
      Given I have uploaded the "wario.png" image as my profile picture
      When I go to the edit profile picture page for "myself"
      Then I should see the "wario.png" profile picture for profile
