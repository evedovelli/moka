include ActionDispatch::TestProcess

### GIVEN ###

Given /^"([^"]*)" has (\d+) votes$/ do |option, votes|
  FactoryGirl.create_list(:vote, votes.to_i, {:option_id => Option.find_by_name(option).id})
end

Given /^"([^"]*)" had (\d+) votes (\d+) hours ago$/ do |option, votes, hours|
  now = Time.current
  Timecop.travel(Time.current - hours.to_i.hours)
  FactoryGirl.create_list(:vote, votes.to_i, {:option_id => Option.find_by_name(option).id})
  Timecop.travel(now)
end

Given /^"([^"]*)" had (\d+) votes just now$/ do |option, votes|
  step %Q{"#{option}" has #{votes} votes}
end

### WHEN ###

When /^I vote for "([^"]*)"$/ do |option|
  find("#vote_option#{Option.find_by_name(option).id}").click
end

When /^I vote for "([^"]*)" for the (\d+)(?:st|nd|rd|th) battle$/ do |option, battle_id|
  expect(page).to have_css("#vote_option#{Option.find_by_name(option).id}")
  within(all('.battle')[battle_id.to_i - 1]) do
    find("#vote_option#{Option.find_by_name(option).id}").click
  end
end

When /^I press the button to vote$/ do
  find("#vote_button").click
end

When /^I close the results overlay$/ do
  find('#close_results').click
end

### THEN ###

Then /^I should see "([^"]*)" with (\d+) vote(?:|s)$/ do |option, votes|
  within(find("#results#{Option.find_by_name(option).id}")) do
    expect(page).to have_content("#{votes} vote")
  end
end

Then /^I should see (\d+) vote(?:|s) for "([^"]*)" for the (\d+)(?:st|nd|rd|th) battle$/ do |votes, option, battle_id|
  within(all('.battle')[battle_id.to_i - 1]) do
    within(find("#results#{Option.find_by_name(option).id}")) do
      expect(page).to have_content("#{votes} vote")
    end
  end
end

Then /^I should see "([^"]*)" option selected$/ do |option|
  within(find("#vote_option#{Option.find_by_name(option).id}")) do
    expect(page).to have_css(".selected_box")
  end
end

Then /^I should see "([^"]*)" option selected for the (\d+)(?:st|nd|rd|th) battle$/ do |option, battle_id|
  within(all('.battle')[battle_id.to_i - 1]) do
    within(find("#vote_option#{Option.find_by_name(option).id}")) do
      expect(page).to have_css(".selected_box")
    end
  end
end

Then /^I should not see "([^"]*)" option selected for the (\d+)(?:st|nd|rd|th) battle$/ do |option, battle_id|
  within(all('.battle')[battle_id.to_i - 1]) do
    within(find("#vote_option#{Option.find_by_name(option).id}")) do
      expect(page).not_to have_css(".selected_box")
    end
  end
end
