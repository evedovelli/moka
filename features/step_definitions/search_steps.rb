include Warden::Test::Helpers
Warden.test_mode!

### WHEN ###

When /^I search for user with "([^"]*)"$/ do |user|
  fill_in("search-field", :with => user)
  click_button("search-user-btn")
end

When /^I search for hashtag with "([^"]*)"$/ do |user|
  fill_in("search-field", :with => user)
  click_button("search-hashtag-btn")
end

