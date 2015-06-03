include ActionDispatch::TestProcess

### GIVEN ###

Given /^the following battles were added:$/ do |table|
  table.hashes.each do |battle|
    FactoryGirl.create(:battle, {:starts_at =>   DateTime.parse(battle[:starts_at]),
                                   :finishes_at => DateTime.parse(battle[:finishes_at])})
  end
end

Given /^(\d+) battles were added$/ do |number|
  date = DateTime.now()
  for i in 1..number.to_i do
    FactoryGirl.create(:battle, { :starts_at   => date,
                                    :finishes_at => date + 5.days })
    date + 7.days
  end
end

Given /^an battle was created with options "([^"]*)" and "([^"]*)"$/ do |option1, option2|
  FactoryGirl.create(:battle, {
    :starts_at   => DateTime.now - 1.day,
    :finishes_at   => DateTime.now + 2.day,
    :option_ids => [
      Option.find_by_name(option1).id,
      Option.find_by_name(option2).id
    ]
  })
end

Given /^an battle was created with options "([^"]*)", "([^"]*)" and "([^"]*)"$/ do |option1, option2, option3|
  FactoryGirl.create(:battle, {
    :starts_at   => DateTime.now - 1.day,
    :finishes_at   => DateTime.now + 2.day,
    :option_ids => [
      Option.find_by_name(option1).id,
      Option.find_by_name(option2).id,
      Option.find_by_name(option3).id
    ]
  })
end

Given /^an battle was created with options "([^"]*)" and "([^"]*)" starting (\d+) hours ago$/ do |option1, option2, hours|
  FactoryGirl.create(:battle, {
    :starts_at   => DateTime.now - hours.to_i.hours,
    :finishes_at   => DateTime.now + 2.day,
    :option_ids => [
      Option.find_by_name(option1).id,
      Option.find_by_name(option2).id
    ]
  })
end

### WHEN ###

When /^I press the button to add new battle$/ do
  find("#add_battle").click
  # This sleep should not be necessary in a unix environment. The "expect" below blocks
  # until css appears (with a timeout). But I am using Windows and facing some timing
  # problems for tests with selenium and my version of Firefox, so I will let this sleep
  # and remove it when I move to a unix environment.
  sleep 0.5
  expect(page).to have_css(%Q{form[id="new_battle"]})
end

When /^I follow the link to remove (\d+)(?:st|nd|rd|th) battle$/ do |id|
  find("#delete_battle#{id}").click
end

When /^I press the button to edit (\d+)(?:st|nd|rd|th) battle$/ do |id|
  find("#edit_battle#{id}").click
end


### THEN ###

Then /^I should not see the new battle form$/ do
  expect(page).not_to have_css(%Q{form[id="new_battle"]})
end

Then /^I should see the new battle form$/ do
  expect(page).to have_css(%Q{form[id="new_battle"]})
end

Then /^I should see an error for the number of options$/ do
  expect(page).to have_content("not enough (minimum is 2)")
end

Then /^I should see an error for finishes_at$/ do
  expect(page).to have_content("should be later than the start date")
end

Then /^I should see (\d+) battles$/ do |number|
  within(find("#battle_index")) do
    expect(all('.battle').count).to eq(number.to_i)
  end
end

Then /^I should not see the battle that starts on "([^"]*)"$/ do |starts_at|
  expect(page).not_to have_content(starts_at)
end

Then /^I should see the battle that starts on "([^"]*)"$/ do |starts_at|
  expect(page).to have_content(starts_at)
end

Then /^I should not see the edit battle form for (\d+)(?:st|nd|rd|th) battle$/ do |id|
  expect(page).not_to have_css("#edit_battle_#{id}")
end

Then /^I should see the edit form for the (\d+)(?:st|nd|rd|th) battle$/ do |id|
  expect(page).to have_css("#edit_battle_#{id}")
end

Then /^I should see the button to add battles$/ do
  expect(page).to have_css("#add_battle")
end

Then /^I should not see the button to add battles$/ do
  expect(page).not_to have_css("#add_battle")
end

Then /^I should see the button to remove (\d+)(?:st|nd|rd|th) battle$/ do |id|
  expect(page).to have_css("#delete_battle#{id}")
end

Then /^I should not see the button to remove (\d+)(?:st|nd|rd|th) battle$/ do |id|
  expect(page).not_to have_css("#delete_battle#{id}")
end

Then /^I should see the button to edit (\d+)(?:st|nd|rd|th) battle$/ do |id|
  expect(page).to have_css("#edit_battle#{id}")
end

Then /^I should not see the button to edit (\d+)(?:st|nd|rd|th) battle$/ do |id|
  expect(page).not_to have_css("#edit_battle#{id}")
end

Then /^I should see statistics link for (\d+)(?:st|nd|rd|th) battle$/ do |id|
  expect(page).to have_css("#more_battle#{id}")
end

Then /^I should not see statistics link for (\d+)(?:st|nd|rd|th) battle$/ do |id|
  expect(page).not_to have_css("#more_battle#{id}")
end

Then /^I should see total of votes (\d+)$/ do |votes|
  within(find("#battle_total")) do
    expect(page).to have_content("Total of votes: #{votes}")
  end
end

Then /^I should see (\d+) votes for "([^"]*)"$/ do |votes, option|
  expect(page).to have_content("#{option} #{votes} votes")
end

Then /^I should see (\d+) votes in the (\d+)(?:st|nd|rd|th) hour$/ do |votes, hour|
  results_by_hour = JSON.parse(find("#data_hours")["data-hours"])
  expect(results_by_hour["datasets"][0]["data"][hour.to_i - 1]).to eq(votes.to_i)
end

# %Q{{"labels": ["21/10/15 -  4h","21/10/15 -  5h","21/10/15 -  6h","21/10/15 -  7h"], "datasets":[{"label":"Battle 1","fillColor":"rgba(255,107,10,0.5)","strokeColor":"rgba(255,107,10,0.8)","highlightFill":"rgba(255,107,10,0.75)","highlightStroke":"rgba(255,107,10,1)","data":[0,5,10,2]}]}}

