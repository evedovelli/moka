include ActionDispatch::TestProcess

### GIVEN ###

Given /^I have disabled email reception for new followers$/ do
  User.find_by_username("myself").email_settings.update_attributes({new_follower: false})
end

### WHEN ###

When /^I click to edit email settings$/ do
  find("#user_email_settings_tab").click
end

When /^I disable email reception for new followers$/ do
  find("#email_settings_new_follower").set(false)
end

When /^I enable email reception for new followers$/ do
  find("#email_settings_new_follower").set(true)
end

When /^I update email settings$/ do
  find("#update_email_settings").click
end

