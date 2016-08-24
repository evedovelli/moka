include ActionDispatch::TestProcess

### GIVEN ###

Given /^"([^"]*)" has commented "([^"]*)" for "([^"]*)"$/ do |user, comment, option|
  FactoryGirl.create(:comment, {
                       :option_id => Option.find_by_name(option).id,
                       :user => User.find_by_username(user),
                       :body => comment
                     })
end

Given /^I have commented "([^"]*)" for "([^"]*)"$/ do |comment, option|
  FactoryGirl.create(:comment, {
                       :option_id => Option.find_by_name(option).id,
                       :user => User.find_by_username("myself"),
                       :body => comment
                     })
end

Given /^there are (\d+) comments for "([^"]*)"$/ do |comments, option|
  for i in 1..comments.to_i do
    FactoryGirl.create(:comment, {
                         :option_id => Option.find_by_name(option).id,
                         :user => User.find_by_username("myself"),
                         :body => "comment #{i}"
                       })
  end
end


### WHEN ###

When /^I click to comment for "([^"]*)"$/ do |option|
  find("#btn-comments-option#{Option.find_by_name(option).id}").click
  expect(page).to have_css(".comments-modal")
end

When /^I click to comment for option "([^"]*)"$/ do |option|
  find("#btn-comments-option#{Option.find_by_name(option).id}").click
  expect(page).to have_css("#login-modal")
end

When /^I click to see comments for "([^"]*)"$/ do |option|
  step %Q{I click to comment for "#{option}"}
end

When /^I comment "([^"]*)" for "([^"]*)"$/ do |comment, option|
  find("#btn-comments-option#{Option.find_by_name(option).id}").click
  find(".text-comment").set(comment)
  find(".submit_form").click
end

When /^I destroy comment "([^"]*)"$/ do |comment|
  within(all(".comments-modal").first) do
    find("#icon-delete-comment#{Comment.find_by_body(comment).id}").click
    expect(page).not_to have_css("#icon-delete-comment#{Comment.find_by_body(comment).id}")
  end
end

When /^I destroy comment "([^"]*)" from "([^"]*)"$/ do |comment, option|
  within(find("#top-comments-option#{Option.find_by_name(option).id}")) do
    find("#icon-delete-comment#{Comment.find_by_body(comment).id}").click
  end
end

When /^I click to load more comments$/ do
  expect(page).to have_css(".comments-modal")
  page.execute_script("window.scrollBy(0,0)")
  all(".next_page-comments").first.click
  sleep 1
end


### THEN ###

Then /^I should see the newest comment "([^"]*)" for "([^"]*)"$/ do |comment, option|
  within("#comments-option#{Option.find_by_name(option).id}") do
    within(all('tr').last) do
      expect(page).to have_content(comment)
    end
  end
end

Then /^I should not see button to destroy comment$/ do
  expect(page).not_to have_css(".delete_comment")
end

Then /^I should see comments from (\d+) up to (\d+)$/ do |first, last|
  for i in first.to_i..last.to_i
    expect(page).to have_content("comment #{i}")
  end
  expect(page).not_to have_content("comment #{first.to_i - 1}")
  expect(page).not_to have_content("comment #{last.to_i + 1}")
end
