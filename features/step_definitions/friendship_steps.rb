include ActionDispatch::TestProcess

### GIVEN ###

Given /^I am following "([^"]*)"$/ do |friend|
  FactoryGirl.create(:friendship, {
                                    :user => User.find_by_username("myself"),
                                    :friend => User.find_by_username(friend)
                                  })
end

Given /^"([^"]*)" is following "([^"]*)"$/ do |user, friend|
  FactoryGirl.create(:friendship, {
                                    :user => User.find_by_username(user),
                                    :friend => User.find_by_username(friend)
                                  })
end


### WHEN ###

When /^I click the "([^"]*)" button$/ do |button|
  find(".btn-#{button}").click
end

When /^I click the "([^"]*)" button for user "([^"]*)"$/ do |button, user|
  within("#user-button#{User.find_by_username(user).id}") do
    find(".btn-#{button}").click
  end
end

When /^I click the following button$/ do
  find(".btn-following").click
end

When /^I click the followers button$/ do
  find(".btn-followers").click
end

When /^I close the login form$/ do
  find("#close-login-form").click
end

### THEN ###

Then /^I should see "([^"]*)" with button to "([^"]*)"$/ do |user, button|
  within("#friend#{User.find_by_username(user).id}") do
    expect(page).to have_content(user)
    expect(page).to have_css(".btn-#{button}")
  end
end

Then /^I should see "([^"]*)" in friendship list$/ do |user|
  within("#friend#{User.find_by_username(user).id}") do
    expect(page).to have_content(user)
  end
end

Then /^I should see a button to "([^"]*)"$/ do |button|
  expect(page).to have_css(".btn-#{button}")
end

