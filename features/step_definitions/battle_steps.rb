include ActionDispatch::TestProcess

def create_path(image_name)
  filepath = Rails.root.join('spec', 'fixtures', 'images', image_name).to_path
  if filepath.match(/^[A-Z]:\//)
    filepath.gsub!(/\//, "\\")
  end
  return filepath
end


### GIVEN ###

Given /^the following battles were added:$/ do |table|
  table.hashes.each do |battle|
    o1 = FactoryGirl.create(:option, { name: "Potato", picture: Rack::Test::UploadedFile.new(create_path('chips.png'), 'image/png') })
    o2 = FactoryGirl.create(:option, { name: "Tomato", picture: Rack::Test::UploadedFile.new(create_path('tomato.png'), 'image/png') })
    FactoryGirl.create(:battle, { options: [o1, o2],
                                  number_of_options: 0,
                                  starts_at: battle[:starts_at],
                                  duration: battle[:duration]
                                })
  end
end

Given /^(\d+) battles were added$/ do |number|
  date = DateTime.now()
  for i in 1..number.to_i do
    FactoryGirl.create(:battle, { :starts_at => date,
                                  :duration => 60*24*5 })
    date + 7.days
  end
end

Given /^a battle was created with options "([^"]*)" and "([^"]*)"$/ do |option1, option2|
  FactoryGirl.create(:battle, {
    :starts_at => DateTime.now - 1.day,
    :duration => 47*60,
    :number_of_options => 0,
    :options => [
      FactoryGirl.create(:option, { name: option1, picture: Rack::Test::UploadedFile.new(create_path('vader.jpg'), 'image/jpeg') }),
      FactoryGirl.create(:option, { name: option2, picture: Rack::Test::UploadedFile.new(create_path('vader.jpg'), 'image/jpeg') })
    ]
  })
end

Given /^a battle was created with options "([^"]*)", "([^"]*)" and "([^"]*)"$/ do |option1, option2, option3|
  FactoryGirl.create(:battle, {
    :starts_at => DateTime.now - 1.day,
    :duration => 48*60,
    :number_of_options => 0,
    :options => [
      FactoryGirl.create(:option, { name: option1, picture: Rack::Test::UploadedFile.new(create_path('vader.jpg'), 'image/jpeg') }),
      FactoryGirl.create(:option, { name: option2, picture: Rack::Test::UploadedFile.new(create_path('vader.jpg'), 'image/jpeg') }),
      FactoryGirl.create(:option, { name: option3, picture: Rack::Test::UploadedFile.new(create_path('vader.jpg'), 'image/jpeg') })
    ]
  })
end

Given /^a battle was created with options "([^"]*)" and "([^"]*)" starting (\d+) hours ago$/ do |option1, option2, hours|
  FactoryGirl.create(:battle, {
    :starts_at => DateTime.now - hours.to_i.hours,
    :duration => 48*60,
    :number_of_options => 0,
    :options => [
      FactoryGirl.create(:option, { name: option1, picture: Rack::Test::UploadedFile.new(create_path('vader.jpg'), 'image/jpeg') }),
      FactoryGirl.create(:option, { name: option2, picture: Rack::Test::UploadedFile.new(create_path('vader.jpg'), 'image/jpeg') })
    ]
  })
end

Given /^a battle was created with images "([^"]*)" and "([^"]*)"$/ do |image1, image2|
  FactoryGirl.create(:battle, {
    :starts_at => DateTime.now - 1.day,
    :duration => 47*60,
    :number_of_options => 0,
    :options => [
      FactoryGirl.create(:option, { picture: Rack::Test::UploadedFile.new(create_path(image1), 'image/jpeg') }),
      FactoryGirl.create(:option, { picture: Rack::Test::UploadedFile.new(create_path(image2), 'image/jpeg') })
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
  # This sleep should not be necessary in a unix environment. The "expect" below blocks
  # until css appears (with a timeout). But I am using Windows and facing some timing
  # problems for tests with selenium and my version of Firefox, so I will let this sleep
  # and remove it when I move to a unix environment.
  sleep 0.5
  expect(page).to have_content("Compose your battle")
end

When /^I add (\d+)(?:st|nd|rd|th) option "([^"]*)" with picture "([^"]*)"$/ do |option_number, option, picture|
  within(all('.options')[0]) do
    within(all('.fields')[option_number.to_i - 1]) do
      attach_option_picture(picture)
      find(".option_name").set(option)
    end
  end
end

When /^I remove (\d+)(?:st|nd|rd|th) option$/ do |option_number|
  all(".remove_option_form")[option_number.to_i - 1].click
end

When /^I wait (\d+) second(?:|s) for uploading images$/ do |time|
  sleep time.to_f
end

When /^I cancel battle edition$/ do
  find(".remove_form").click
end

When /^I cancel battle creation$/ do
  find(".remove_form").click
end

When /^I press the button to add option$/ do
  find("#add_new_option").click
end

When /^I select "([^"]*)" image for (\d+)(?:st|nd|rd|th) option$/ do |image, option_number|
  expect(page).to have_content("Compose your battle")
  within(all('.options')[0]) do
    within(all('.fields')[option_number.to_i - 1]) do
      attach_option_picture(image)
    end
  end
end

When /^I remove (\d+)(?:st|nd|rd|th) image$/ do |id|
  all('.delete_picture')[id.to_i - 1].click
end

### THEN ###

Then /^I should not see the new battle form$/ do
  expect(page).not_to have_css(%Q{form[id="new_battle"]})
end

Then /^I should see the new battle form$/ do
  expect(page).to have_css(%Q{form[id="new_battle"]})
end

Then /^I should see an error for the number of options$/ do
  expect(page).to have_content("You must specify at least 2 options")
end

Then /^I should see an error for duration$/ do
  expect(page).to have_content("Value must be greater than zero")
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

Then /^I should see the button to add (\d+)(?:st|nd|rd|th) image$/ do |id|
  within(all(".option-box")[id.to_i - 1]) do
    within(find(".no_picture_container")) do
      expect(page).to have_content("Click here to add image")
    end
    expect(page).not_to have_css(".picture_preview")
    expect(page).not_to have_css(".upload_picture")
    expect(page).not_to have_css(".delete_picture")
  end
end

Then /^I should see the preview of the image for (\d+)(?:st|nd|rd|th) option$/ do |id|
  within(all(".option-box")[id.to_i - 1]) do
    expect(page).to have_css(".picture_preview")
    expect(page).to have_css(".delete_picture")
    expect(page).not_to have_css(".upload_picture")
    expect(page).not_to have_css(".no_picture_container")
  end
end

