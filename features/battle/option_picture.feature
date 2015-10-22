Feature: Option picture
  To easily describe an option
  It should be easy and intuitive for an user to submit an image
  representing the option for a battle

Background:
    Given I am logged in

    @javascript
    Scenario: User may upload picture
      When I go to the home page
      And I press the button to add new battle
      Then I should see the button to add 1st image
      And I should see the button to add 2nd image

    @javascript
    Scenario: User may add options and upload pictures
      When I go to the home page
      And I press the button to add new battle
      And I press the button to add option
      Then I should see the button to add 3rd image

    @javascript
    Scenario: User selects image and see preview
      When I go to the home page
      And I press the button to add new battle
      And I select "dick_dastardly.jpg" image for 2nd option
      Then I should see the preview of the image for 2nd option
      And I should see the button to add 1st image

    @javascript
    Scenario: User sees upload message after removing image preview
      When I go to the home page
      And I press the button to add new battle
      And I select "dick_dastardly.jpg" image for 2nd option
      And I select "devil_robot.jpg" image for 1st option
      And I remove 2nd image
      Then I should see the preview of the image for 1st option
      And I should see the button to add 2nd image

    @javascript
    Scenario: User uploads images successfully
      When I go to the home page
      And I press the button to add new battle
      And I add 1st option "Dick Dastardly" with picture "dick_dastardly.jpg"
      And I add 2nd option "Devil Robot" with picture "devil_robot.jpg"
      And I press "Create"
      And I wait 2 seconds for uploading images
      Then I should see the image "dick_dastardly.jpg"
      And I should see the image "devil_robot.jpg"

    @javascript
    Scenario: User sees existing images when editing battle
      Given a battle was created with images "palpatine.jpg" and "devil_robot.jpg"
      When I go to the home page
      And I press the button to edit 1st battle
      Then I should see the image "palpatine.jpg"
      And I should see the image "devil_robot.jpg"

    @javascript
    Scenario: User can add image when editing battle
      Given a battle was created with images "palpatine.jpg" and "devil_robot.jpg"
      When I go to the home page
      And I press the button to edit 1st battle
      And I press the button to add option
      Then I should see the button to add 3rd image
      And I should see the image "palpatine.jpg"
      And I should see the image "devil_robot.jpg"

    @javascript
    Scenario: User sees preview of added images when editing battle
      Given a battle was created with images "palpatine.jpg" and "devil_robot.jpg"
      When I go to the home page
      And I press the button to edit 1st battle
      And I press the button to add option
      And I select "dick_dastardly.jpg" image for 3rd option
      Then I should see the preview of the image for 3rd option
      And I should see the image "palpatine.jpg"
      And I should see the image "devil_robot.jpg"

    @javascript
    Scenario: User sees successfully updates images
      Given a battle was created with images "palpatine.jpg" and "devil_robot.jpg"
      When I go to the home page
      And I press the button to edit 1st battle
      And I press the button to add option
      And I add 3rd option "Dick Dastardly" with picture "dick_dastardly.jpg"
      And I select "vader.jpg" image for 1st option
      And I press "Update"
      And I wait 2 seconds for uploading images
      Then I should see the image "vader.jpg"
      And I should see the image "devil_robot.jpg"
      And I should see the image "dick_dastardly.jpg"
      And I should not see the image "palpatine.jpg"

