include ActionDispatch::TestProcess

### GIVEN ###

Given /^"([^"]*)" has (\d+) votes$/ do |option, votes|
  for vote in 1..votes.to_i do
    FactoryGirl.create(:vote, {
      :option_id => Option.find_by_name(option).id,
    })
  end
end

Given /^"([^"]*)" had (\d+) votes (\d+) hours ago$/ do |option, votes, hours|
  now = Time.current
  Timecop.travel(Time.current - hours.to_i.hours)
  for vote in 1..votes.to_i do
    FactoryGirl.create(:vote, {
      :option_id => Option.find_by_name(option).id
    })
  end
  Timecop.travel(now)
end

Given /^"([^"]*)" had (\d+) votes just now$/ do |option, votes|
  step %Q{"#{option}" has #{votes} votes}
end

Given /^captcha is enabled$/ do
  Recaptcha.configuration.skip_verify_env.delete("test")
end

### WHEN ###

When /^I vote for "([^"]*)"$/ do |option|
  find("#vote_picture_borther#{Option.find_by_name(option).id}").click
  find("#vote_button").click
end

When /^I press the button to vote$/ do
  find("#vote_button").click
end

When /^I close the results overlay$/ do
  find('#close_results').click
end

### THEN ###

Then /^I should see "([^"]*)" with (\d+)\.0% of votes$/ do |option, percent|
  expect(page).to have_content("#{option} #{percent}.0% of votes")
end

Then /^captcha should be disabled$/ do
  Recaptcha.configuration.skip_verify_env.push("test")
end
