include Warden::Test::Helpers
Warden.test_mode!

### WHEN ###

When /^I search for user with "([^"]*)"$/ do |user|
  if defined? page.driver.browser.manage
    page.driver.browser.manage.window.resize_to(1920, 1080)
  end
  fill_in("search-field", :with => user)
  click_button("search-user-btn")
end

When /^I search for hashtag with "([^"]*)"$/ do |user|
  if defined? page.driver.browser.manage
    page.driver.browser.manage.window.resize_to(1920, 1080)
  end
  fill_in("search-field", :with => user)
  click_button("search-hashtag-btn")
end

