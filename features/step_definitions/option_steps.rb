include ActionDispatch::TestProcess

### GIVEN ###

Given /^the following options were added:$/ do |table|
  table.hashes.each do |option|
    FactoryGirl.create(:option, { :name => option[:name], :picture => option[:picture] })
  end
end

### WHEN ###

When /^I press the button to add new option$/ do
  find("#add_option").click
  # This sleep should not be necessary in a unix environment. The "expect" below blocks
  # until css appears (with a timeout). But I am using Windows and facing some timing
  # problems for tests with selenium and my version of Firefox, so I will let this sleep
  # and remove it when I move to a unix environment.
  sleep 0.5
  expect(page).to have_css(%Q{form[id="new_option"]})
end

When /^I follow the link to remove option "([^"]+)"$/ do |option|
  click_link("delete_option#{Option.find_by_name(option)[:id]}")
end

When /^I select picture number (\d+)$/ do |pic|
  find(".picture#{pic}").click
end


### THEN ###

Then /^I should not see the new option form$/ do
  expect(page).not_to have_css(%Q{form[id="new_option"]})
end

Then /^I should see the new option form$/ do
  expect(page).to have_css(%Q{form[id="new_option"]})
end

Then /^I should see a missing name error message$/ do
  within(find('#option_name').first(:xpath,".//..")) do
    expect(page).to have_content "can't be blank"
  end
end

Then /^I should see picture number (\d+) for "([^"]+)"$/ do |pic, name|
  within(find("#option#{Option.find_by_name(name)[:id]}")) do
    expect(page).to have_css("#picture_option#{Option.find_by_name(name)[:id]}")
    expect(page).to have_css(".picture#{pic}")
  end
end

Then /^I should see the button to add options$/ do
  expect(page).to have_css("#add_option")
end

Then /^I should not see the button to add options$/ do
  expect(page).not_to have_css("#add_option")
end

Then /^I should see the button to remove "([^"]+)"$/ do |name|
  expect(page).to have_css("#delete_option#{Option.find_by_name(name)[:id]}")
end

Then /^I should not see the button to remove "([^"]+)"$/ do |name|
  expect(page).not_to have_css("#delete_option#{Option.find_by_name(name)[:id]}")
end

