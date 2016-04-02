include ActionDispatch::TestProcess

### GIVEN ###

Given /^"([^"]+)" logs in and votes for "([^"]+)"$/ do |user, option|
  click_link("Logout")
  within("#flash_notice") do
    expect(page).to have_content("Signed out successfully")
  end
  step %Q{I go to the sign in page}
  sign_in("#{user}@email.com", "#{user}password")
  step %Q{I go to the 1st battle page}
  step %Q{I vote for "#{option}"}
  click_link("Logout")
  within("#flash_notice") do
    expect(page).to have_content("Signed out successfully")
  end
  sign_in("myself@email.com", "secretpassword")
end

Given /^"([^"]+)" logs in and follows me$/ do |user|
  click_link("Logout")
  within("#flash_notice") do
    expect(page).to have_content("Signed out successfully")
  end
  step %Q{I go to the sign in page}
  sign_in("#{user}@email.com", "#{user}password")
  step %Q{I go to my profile page}
  step %Q{I click the "follow" button}
  click_link("Logout")
  within("#flash_notice") do
    expect(page).to have_content("Signed out successfully")
  end
  sign_in("myself@email.com", "secretpassword")
end

Given /^"([^"]+)" logs in and unfollows me$/ do |user|
  click_link("Logout")
  within("#flash_notice") do
    expect(page).to have_content("Signed out successfully")
  end
  step %Q{I go to the sign in page}
  sign_in("#{user}@email.com", "#{user}password")
  step %Q{I go to my profile page}
  step %Q{I click the "unfollow" button}
  click_link("Logout")
  within("#flash_notice") do
    expect(page).to have_content("Signed out successfully")
  end
  sign_in("myself@email.com", "secretpassword")
end

Given /^I have 36 notifications$/ do
  user = User.find_by_username("myself")
  for i in 1..18
    sender = FactoryGirl.create(:user, username: "sender_#{i}", email: "sender_#{i}@sender.com")
    vote = FactoryGirl.create(:vote, user: sender, option: Option.find_by_id(1))
    VoteNotification.create!({
      user: user,
      sender: sender,
      vote: vote
    })
    Timecop.travel(DateTime.now + 1.minute)
    FriendshipNotification.create!({
      user: user,
      sender: sender
    })
    Timecop.travel(DateTime.now + 1.minute)
  end
end

Given /^"([^"]+)" has logged in and voted for "([^"]+)"$/ do |user, option|
  step %Q{I go to the sign in page}
  sign_in("#{user}@email.com", "#{user}password")
  step %Q{I go to the 1st battle page}
  step %Q{I vote for "#{option}"}
  click_link("Logout")
  within("#flash_notice") do
    expect(page).to have_content("Signed out successfully")
  end
end


### WHEN ###

When /^I click the notifications button$/ do
  find("#notifications-btn").click
end

When /^I click the all notifications button$/ do
  within(all(".notification-all")[0]) do
    find("a").click
  end
end

### THEN ###

Then /^I should see (\d+) notification(?:|s) alert$/ do |notifications|
  within("#notifications-unread") do
    expect(page).to have_content(notifications)
  end
end

Then /^I should not see notification alert$/ do
  expect(page).to have_css("#notifications-none")
end

Then /^I should see the notification "([^"]*)" in dropdown menu$/ do |notification|
  within("#notification-dropdown") do
    expect(page).to have_content(notification)
  end
end

Then /^I should see the notification "([^"]*)"$/ do |notification|
  within("#notification-index") do
    expect(page).to have_content(notification)
  end
end

Then /^I should see option "([^"]*)" selected for newest notification$/ do |selected_option|
  within(all(".notification")[0]) do
    within("#option#{Option.find_by_name(selected_option).id}-icon") do
      expect(page).to have_css(".voted_battle")
    end
  end
end

Then /^I should see (\d+) notification(?:|s)$/ do |notifications|
  expect(all(".notification").size).to be_equal(notifications.to_i)
end

Then /^I should see the (\d+) last from 36 notifications$/ do |last|
  user = User.find_by_username("myself")
  for i in (18).downto(18 - last.to_i/2 + 1)
    within(all(".notification")[36 - i*2]) do
      expect(page).to have_content("sender_#{i} is now following you.")
    end
    within(all(".notification")[36 - i*2 + 1]) do
      expect(page).to have_content("sender_#{i} has voted in your battle.")
    end
  end
end


