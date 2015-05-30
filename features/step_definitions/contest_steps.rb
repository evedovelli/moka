include ActionDispatch::TestProcess

### GIVEN ###

Given /^the following contests were added:$/ do |table|
  table.hashes.each do |contest|
    FactoryGirl.create(:contest, {:starts_at =>   DateTime.parse(contest[:starts_at]),
                                   :finishes_at => DateTime.parse(contest[:finishes_at])})
  end
end

Given /^(\d+) contests were added$/ do |number|
  date = DateTime.now()
  for i in 1..number.to_i do
    FactoryGirl.create(:contest, { :starts_at   => date,
                                    :finishes_at => date + 5.days })
    date + 7.days
  end
end

Given /^an contest was created with stuffs "([^"]*)" and "([^"]*)"$/ do |stuff1, stuff2|
  FactoryGirl.create(:contest, {
    :starts_at   => DateTime.now - 1.day,
    :finishes_at   => DateTime.now + 2.day,
    :stuff_ids => [
      Stuff.find_by_name(stuff1).id,
      Stuff.find_by_name(stuff2).id
    ]
  })
end

Given /^an contest was created with stuffs "([^"]*)", "([^"]*)" and "([^"]*)"$/ do |stuff1, stuff2, stuff3|
  FactoryGirl.create(:contest, {
    :starts_at   => DateTime.now - 1.day,
    :finishes_at   => DateTime.now + 2.day,
    :stuff_ids => [
      Stuff.find_by_name(stuff1).id,
      Stuff.find_by_name(stuff2).id,
      Stuff.find_by_name(stuff3).id
    ]
  })
end

Given /^an contest was created with stuffs "([^"]*)" and "([^"]*)" starting (\d+) hours ago$/ do |stuff1, stuff2, hours|
  FactoryGirl.create(:contest, {
    :starts_at   => DateTime.now - hours.to_i.hours,
    :finishes_at   => DateTime.now + 2.day,
    :stuff_ids => [
      Stuff.find_by_name(stuff1).id,
      Stuff.find_by_name(stuff2).id
    ]
  })
end

### WHEN ###

When /^I press the button to add new contest$/ do
  find("#add_contest").click
  # This sleep should not be necessary in a unix environment. The "expect" below blocks
  # until css appears (with a timeout). But I am using Windows and facing some timing
  # problems for tests with selenium and my version of Firefox, so I will let this sleep
  # and remove it when I move to a unix environment.
  sleep 0.5
  expect(page).to have_css(%Q{form[id="new_contest"]})
end

When /^I follow the link to remove (\d+)(?:st|nd|rd|th) contest$/ do |id|
  find("#delete_contest#{id}").click
end

When /^I press the button to edit (\d+)(?:st|nd|rd|th) contest$/ do |id|
  find("#edit_contest#{id}").click
end


### THEN ###

Then /^I should not see the new contest form$/ do
  expect(page).not_to have_css(%Q{form[id="new_contest"]})
end

Then /^I should see the new contest form$/ do
  expect(page).to have_css(%Q{form[id="new_contest"]})
end

Then /^I should see an error for the number of stuffs$/ do
  expect(page).to have_content("not enough (minimum is 2)")
end

Then /^I should see an error for finishes_at$/ do
  expect(page).to have_content("should be later than the start date")
end

Then /^I should see (\d+) contests$/ do |number|
  within(find("#contest_index")) do
    expect(all('.contest').count).to eq(number.to_i)
  end
end

Then /^I should not see the contest that starts on "([^"]*)"$/ do |starts_at|
  expect(page).not_to have_content(starts_at)
end

Then /^I should see the contest that starts on "([^"]*)"$/ do |starts_at|
  expect(page).to have_content(starts_at)
end

Then /^I should not see the edit contest form for (\d+)(?:st|nd|rd|th) contest$/ do |id|
  expect(page).not_to have_css("#edit_contest_#{id}")
end

Then /^I should see the edit form for the (\d+)(?:st|nd|rd|th) contest$/ do |id|
  expect(page).to have_css("#edit_contest_#{id}")
end

Then /^I should see the button to add contests$/ do
  expect(page).to have_css("#add_contest")
end

Then /^I should not see the button to add contests$/ do
  expect(page).not_to have_css("#add_contest")
end

Then /^I should see the button to remove (\d+)(?:st|nd|rd|th) contest$/ do |id|
  expect(page).to have_css("#delete_contest#{id}")
end

Then /^I should not see the button to remove (\d+)(?:st|nd|rd|th) contest$/ do |id|
  expect(page).not_to have_css("#delete_contest#{id}")
end

Then /^I should see the button to edit (\d+)(?:st|nd|rd|th) contest$/ do |id|
  expect(page).to have_css("#edit_contest#{id}")
end

Then /^I should not see the button to edit (\d+)(?:st|nd|rd|th) contest$/ do |id|
  expect(page).not_to have_css("#edit_contest#{id}")
end

Then /^I should see statistics link for (\d+)(?:st|nd|rd|th) contest$/ do |id|
  expect(page).to have_css("#more_contest#{id}")
end

Then /^I should not see statistics link for (\d+)(?:st|nd|rd|th) contest$/ do |id|
  expect(page).not_to have_css("#more_contest#{id}")
end

Then /^I should see total of votes (\d+)$/ do |votes|
  within(find("#contest_total")) do
    expect(page).to have_content("Total of votes: #{votes}")
  end
end

Then /^I should see (\d+) votes for "([^"]*)"$/ do |votes, stuff|
  expect(page).to have_content("#{stuff} #{votes} votes")
end

Then /^I should see (\d+) votes in the (\d+)(?:st|nd|rd|th) hour$/ do |votes, hour|
  results_by_hour = JSON.parse(find("#data_hours")["data-hours"])
  expect(results_by_hour["datasets"][0]["data"][hour.to_i - 1]).to eq(votes.to_i)
end

# %Q{{"labels": ["21/10/15 -  4h","21/10/15 -  5h","21/10/15 -  6h","21/10/15 -  7h"], "datasets":[{"label":"Contest 1","fillColor":"rgba(255,107,10,0.5)","strokeColor":"rgba(255,107,10,0.8)","highlightFill":"rgba(255,107,10,0.75)","highlightStroke":"rgba(255,107,10,1)","data":[0,5,10,2]}]}}

