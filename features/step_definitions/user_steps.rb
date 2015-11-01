include Warden::Test::Helpers
Warden.test_mode!

### UTILITY METHODS ###

def create_user(username, email, password, name=nil)
  delete_user(email)
  return FactoryGirl.create(:user,
                            :username => username,
                            :email => email,
                            :password => password,
                            :password_confirmation => password,
                            :name => name)
end

def delete_user(email)
  user = User.where(:email => email).first
  user.destroy unless user.nil?
end

def sign_up(username, email, password, password_confirmation=password)
  delete_user(email)
  visit '/users/sign_up'
  fill_in "user_username", :with => username
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  fill_in "user_password_confirmation", :with => password_confirmation
  click_button "Sign up"
end

def sign_in(email, password)
  visit '/users/sign_in'
  fill_in "user_login", :with => email
  fill_in "user_password", :with => password
  click_button "Sign in"
end

### GIVEN ###
Given /^I am not logged in$/ do
  logout(:user)
end

Given /^I am logged in$/ do
  create_user("myself", "myself@email.com", "secretpassword")
  sign_in("myself@email.com", "secretpassword")
end

Given /^I exist as an user$/ do
  create_user("myself", "myself@email.com", "secretpassword")
end

Given /^user "([^"]*)" exists$/ do |user|
  create_user(user, "#{user}@email.com", "#{user}password")
end

Given /^the following users exist:$/ do |table|
  table.hashes.each do |user|
    create_user(user[:username],
                user[:email] || "#{user[:username]}@email.com",
                user[:password] || "#{user[:username]}password",
                user[:name] || user[:username])
  end
end

Given /^I do not exist as an user$/ do
  delete_user("myself@email.com")
end

Given /^I am an admin(?:|istrator)$/ do
  User.find_by_email("myself@email.com").add_role :admin
end

Given /^I am logged in as an administrator$/ do
  sign_in("myself@email.com", "secretpassword")
  step %Q{I am an administrator}
end

Given /^I have uploaded the "([^"]*)" image as my profile picture$/ do |image|
  user = User.find_by_username("myself")
  user.update_attributes({:avatar => Rack::Test::UploadedFile.new(create_path(image), 'image/png')})
end


### WHEN ###

When /^I sign in(?:| with valid credentials)$/ do
  sign_in("myself@email.com", "secretpassword")
end

When /^I sign in with username$/ do
  sign_in("myself", "secretpassword")
end

When /^I sign in with "([^"]+)"$/ do |username|
  sign_in(username, "secretpassword")
end

When /^I sign in with password "([^"]+)"$/ do |password|
  sign_in("myself@email.com", password)
end

When /^(?:|I )sign out$/ do
  logout(:user)
end

When /^I sign up with username "([^"]+)"$/ do |username|
  sign_up(username, "myself@email.com", "secretpassword")
end

When /^I sign up with valid user data$/ do
  sign_up("myself", "myself@email.com", "secretpassword")
end

When /^I sign up with an invalid email$/ do
  sign_up("myself", "notanemail", "secretpassword")
end

When /^I sign up without an username$/ do
  sign_up("", "myself@email.com", "secretpassword")
end

When /^I sign up without a password confirmation$/ do
  sign_up("myself", "myself@email.com", "secretpassword", "")
end

When /^I sign up without a password$/ do
  sign_up("myself", "myself@email.com", "")
end

When /^I sign up with a mismatched password confirmation$/ do
  sign_up("myself", "myself@email.com", "secretpassword", "passwordsecret")
end

When /^I return to the site$/ do
  visit '/'
end

When /^I sign in with a wrong email$/ do
  sign_in("wrong@email.com", "secretpassword")
end

When /^I sign in with a wrong password$/ do
  sign_in("myself@email.com", "wrongpassword")
end

When /^I edit my account details$/ do
  click_link "Edit profile"
  fill_in "user_current_password", :with => "secretpassword"
  click_button "Update"
end

When /^I edit my username with "([^"]+)"$/ do |username|
  click_link "Edit profile"
  fill_in "user_username", :with => username
  fill_in "user_current_password", :with => "secretpassword"
  click_button "Update"
end

When /^I edit my email with "([^"]+)"$/ do |email|
  click_link "Edit profile"
  fill_in "user_email", :with => email
  fill_in "user_current_password", :with => "secretpassword"
  click_button "Update"
end

When /^I edit my password with "([^"]+)"$/ do |password|
  click_link "Edit profile"
  fill_in "user_password", :with => password
  fill_in "user_password_confirmation", :with => password
  fill_in "user_current_password", :with => "secretpassword"
  click_button "Update"
end

When /^I look at the list of users$/ do
  visit '/users/'
end

When /^I click to edit my profile picture$/ do
  find('.btn-edit-user-avatar').click
end

When /^I select "([^"]*)" image for my profile picture$/ do |picture|
  attach_option_picture(picture)
end

When /^I remove the profile picture uploaded image$/ do
  find('.delete-picture-user').click
end


### THEN ###

Then /^I should be signed in$/ do
  expect(page).to have_content "Logout"
  expect(page).not_to have_content "Sign up"
  expect(page).not_to have_content "Login"
end

Then /^I should be signed out$/ do
  expect(page).not_to have_content "Logout"
end

Then /^I see an unconfirmed account message$/ do
  expect(page).to have_content "You have to confirm your account before continuing."
end

Then /^I see a successful sign in message$/ do
  expect(page).to have_content "Signed in successfully."
end

Then /^I should see a successful sign up message$/ do
  expect(page).to have_content "Welcome! You have signed up successfully."
end

Then /^I should see an invalid email message$/ do
  expect(page).to have_content "Email is invalid"
end

Then /^I should see a missing username message$/ do
  expect(page).to have_content "Username can't be blank"
end

Then /^I should see a missing password message$/ do
  expect(page).to have_content "Password can't be blank"
end

Then /^I should see a missing password confirmation message$/ do
  expect(page).to have_content "Password doesn't match confirmation"
end

Then /^I should see a mismatched password message$/ do
  expect(page).to have_content "Password doesn't match confirmation"
end

Then /^I should see a signed out message$/ do
  expect(page).to have_content "Signed out successfully."
end

Then /^I see an invalid login message$/ do
  expect(page).to have_content "Invalid username or password."
end

Then /^I should see an account edited message$/ do
  expect(page).to have_content "You updated your account successfully."
end

Then /^I should see my email$/ do
  expect(page).to have_content "myself@email.com"
end

Then /^I should not see my email$/ do
  expect(page).not_to have_content "myself@email.com"
end

Then /^I should see my username$/ do
  expect(page).to have_content "myself"
end

Then /^I should see "([^"]*)" as my name$/ do |name|
  within(".name") do
    expect(page).to have_content name
  end
end

Then /^I should see the default profile picture for profile$/ do
  within(all(".avatar-box")[0]) do
    expect(page).to have_xpath("//img[contains(@src, \"missing.png\")]")
  end
end

Then /^I should see the "([^"]*)" profile picture for profile$/ do |image|
  within(all(".avatar-box")[0]) do
    expect(page).to have_xpath("//img[contains(@src, \"#{image}\")]")
  end
end

Then /^I should see the default profile picture for (\d+)(?:st|nd|rd|th) battle$/ do |num|
  within(all(".battle-user")[num.to_i - 1]) do
    expect(page).to have_xpath("//img[contains(@src, \"missing.png\")]")
  end
end

Then /^I should see the "([^"]*)" profile picture for (\d+)(?:st|nd|rd|th) battle$/ do |image, num|
  within(all(".battle-user")[num.to_i - 1]) do
    expect(page).to have_xpath("//img[contains(@src, \"#{image}\")]")
  end
end

Then /^I should see the default profile picture for "([^"]*)"$/ do |user|
  within("#friend#{User.find_by_username(user).id}") do
    expect(page).to have_xpath("//img[contains(@src, \"missing.png\")]")
  end
end

Then /^I should see the "([^"]*)" profile picture for "([^"]*)"$/ do |image, user|
  within("#friend#{User.find_by_username(user).id}") do
    expect(page).to have_xpath("//img[contains(@src, \"#{image}\")]")
  end
end

Then /^I should see the preview of the image for my profile picture$/ do
  expect(page).to have_css(".picture_preview")
  expect(page).to have_css(".delete_picture")
  expect(page).not_to have_css(".upload_picture")
  expect(page).not_to have_css(".no_picture_container")
end

Then /^I should see the preview with the current "([^"]*)" image$/ do |image|
  within(".current_picture") do
    expect(page).to have_xpath("//img[contains(@src, \"#{image}\")]")
  end
end

Then /^I should see the login form$/ do
  expect(page).to have_css("#login-black-box")
end

Then /^I should not see the login form$/ do
  expect(page).not_to have_css("#login-black-box")
end

Then /^I should not see any option selected$/ do
  expect(page).not_to have_css('.outer_selected_picture')
  expect(page).not_to have_css('.selected_picture')
  expect(page).not_to have_css('.selected_box')
end

Then /^I should find user "([^"]*)"$/ do |user|
  expect(page).to have_css("#user#{User.find_by_username(user).id}-search")
end

Then /^I should not find user "([^"]*)"$/ do |user|
  expect(page).not_to have_css("#user#{User.find_by_username(user).id}-search")
end
