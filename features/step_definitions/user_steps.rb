include Warden::Test::Helpers
Warden.test_mode!

### UTILITY METHODS ###

def create_user(username, email, password, name=nil)
  delete_user(email)
  u = FactoryGirl.create(:user,
                         :username => username,
                         :email => email,
                         :password => password,
                         :password_confirmation => password,
                         :name => name)
  FactoryGirl.create(:email_settings, user: u)
  return u
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

def to_boolean(str)
  str != 'false'
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

Given /^I exist as an user with:$/ do |table|
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

Given /^(?:I|the following users) accept to share (?:my|their) Facebook info:$/ do |table|
  table.hashes.each do |user|
    if user[:name]
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        :provider => 'facebook',
        :uid => user[:uid] || '8734210',
        :info => {
          :email => user[:email],
          :name => user[:name],
          :image => user[:picture],
          :verified => to_boolean(user[:verified])
        },
        :credentials => {
          :token => 'ABCDEF',
          :expires_at => 1321747205,
          :expires => true
        },
      })
    else
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        :provider => 'facebook',
        :uid => user[:uid] || '8734210',
        :info => {
          :email => user[:email],
          :verified => to_boolean(user[:verified])
        },
        :credentials => {
          :token => 'ABCDEF',
          :expires_at => 1321747205,
          :expires => true
        },
      })
    end
  end
end

Given /^I have signed up with my Facebook account$/ do
  step %Q{I am on the home page}
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
    :provider => 'facebook',
    :uid => '8734210',
    :info => {
      :email => "myself@email.com",
      :name => "I Myself",
      :image => "profile.jpg",
      :verified => true
    },
    :credentials => {
      :token => 'ABCDEF',
      :expires_at => 1321747205,
      :expires => true
    },
  })
  step %Q{I click in the Sign in with Facebook button}
end

Given /^I am not signed in$/ do
  step %Q{I sign out}
end

Given /^"([^"]+)" preferred language is "([^"]+)"$/ do |user, language|
  u = User.find_by_username(user)
  u.language = language
  u.save
end

Given /^user "([^"]+)" with Facebook's account exists$/ do |user|
  u = create_user(user, "#{user}@email.com", "#{user}password", user)
  id = FactoryGirl.create(:identity,
                     user: u,
                     uid: user,
                     provider: "facebook")
end

Given /^I am friends with "([^"]+)" on Facebook$/ do |friend|
  @facebook_accounts = @facebook_accounts || []
  @facebook_accounts << { "id" => friend }
end

Given /^"([^"]+)" is friends with me on Facebook$/ do |friend|
  @facebook_accounts = @facebook_accounts || []
  @facebook_accounts << { "id" => '8734210' }
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

When /^I sign in with username "([^"]+)" and password "([^"]+)"$/ do |username, password|
  sign_in(username, password)
end

When /^I sign in with password "([^"]+)"$/ do |password|
  sign_in("myself@email.com", password)
end

When /^I sign in with my Facebook account$/ do
  step %Q{I have signed up with my Facebook account}
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
  click_link "Edit account"
  step %Q{I select "English" from "user_language"}
  fill_in "user_current_password", :with => "secretpassword"
  click_button "Update"
end

When /^I edit my username with "([^"]+)"$/ do |username|
  click_link "Edit account"
  fill_in "user_username", :with => username
  step %Q{I select "English" from "user_language"}
  fill_in "user_current_password", :with => "secretpassword"
  click_button "Update"
end

When /^I edit my email with "([^"]+)"$/ do |email|
  click_link "Edit account"
  fill_in "user_email", :with => email
  step %Q{I select "English" from "user_language"}
  fill_in "user_current_password", :with => "secretpassword"
  click_button "Update"
end

When /^I edit my password with "([^"]+)"$/ do |password|
  click_link "Edit account"
  fill_in "user_password", :with => password
  fill_in "user_password_confirmation", :with => password
  step %Q{I select "English" from "user_language"}
  fill_in "user_current_password", :with => "secretpassword"
  click_button "Update"
end

When /^I look at the list of users$/ do
  visit '/users/'
end

When /^I click to edit my profile picture$/ do
  find('.btn-edit-user-avatar').click
  expect(page).to have_css(".avatar_form")
end

When /^I select "([^"]*)" image for my profile picture$/ do |picture|
  attach_option_picture(picture)
end

When /^I remove the profile picture uploaded image$/ do
  find('.delete-picture-user').click
end

When /^I close the login window$/ do
  expect(page).to have_css("#login-modal")
  expect(page).to have_css(".close-login-form")
  within('#login-modal') do
    all('.close-login-form').first.click
  end
end

When /^I click in the Sign in with Facebook button$/ do
  stub_request(:get, "https://graph.facebook.com/v2.0/me/friends?access_token=ABCDEF").
        to_return(:status => 200, :body => "", :headers => {})
  find('#facebook-sign-in').click
end

Then /^I should see my Facebook account connected$/ do
  expect(page).to have_css(".facebook-connected")
end

When /^I click to connect my Facebook account$/ do
  find('#facebook-sign-in').click
end

When /^user "([^"]*)" cancels his account$/ do |user|
  step %Q{I sign in with username "#{user}" and password "#{user}password"}
  step %Q{I go to the edit account page}
  step %Q{I should be on the edit account page}
  find("#destroy-account").click
  step %Q{I confirm popup}
end

When /^I select language "([^"]*)"$/ do |language|
  find("#language-dropdown").click
  within("#language-dropdown-menu") do
    click_link(language)
  end
end

When /^I sign in from modal form$/ do
  within("#login-modal") do
    sleep 0.5
    step %Q{I fill in "user_login" with "myself"}
    step %Q{I fill in "user_password" with "secretpassword"}
    step %Q{I click "Sign in"}
  end
end

When /^I click to find friends from Facebook$/ do
  @graph = double("graph")
  allow(@graph).to receive(:get_connections).with("me", "friends").and_return(@facebook_accounts)
  allow(Koala::Facebook::API).to receive(:new).and_return(@graph)
  find("#facebook-friends-find").click
end

When /^I become friends with "([^"]+)" on Facebook$/ do |friend|
  @facebook_accounts = @facebook_accounts || []
  @facebook_accounts << { "id" => friend }
end

When /^I click to update friends from Facebook$/ do
  find("#facebook-friends-find").click
end

When /^my Facebook friend "([^"]+)" signs up$/ do |user|
  step %Q{I go to the home page}

  @graph = double("graph")
  allow(@graph).to receive(:get_connections).with("me", "friends").and_return(@facebook_accounts)
  allow(Koala::Facebook::API).to receive(:new).and_return(@graph)

  find('#facebook-sign-in').click
  expect(page).to have_content "Logout"
  logout(:user)
end

When /^I click to close the welcome message$/ do
  within(all('.alert-welcome').first) do
    all('.close').first.click
  end
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

Then /^I see a successful sign in from Facebook message$/ do
  expect(page).to have_content "Successfully authenticated from Facebook account"
end

Then /^I should see an invalid email message$/ do
  within(".user_email") do
    expect(page).to have_content "is invalid"
  end
end

Then /^I should see a missing username message$/ do
  within(".user_username") do
    expect(page).to have_content "can't be blank"
  end
end

Then /^I should see an invalid username message$/ do
  within(".user_username") do
    expect(page).to have_content "is invalid"
  end
end

Then /^I should see an invalid characters for username message$/ do
  within(".user_username") do
    expect(page).to have_content "is invalid. Only use letters, numbers and '_'"
  end
end

Then /^I should see a missing password message$/ do
  within(".user_password") do
    expect(page).to have_content "can't be blank"
  end
end

Then /^I should see a missing password confirmation message$/ do
  within(".user_password_confirmation") do
    expect(page).to have_content "doesn't match confirmation"
  end
end

Then /^I should see a mismatched password message$/ do
  within(".user_password") do
    expect(page).to have_content "doesn't match confirmation"
  end
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

Then /^I should see "([^"]*)" as my username$/ do |username|
  within(".username") do
    expect(page).to have_content username
  end
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
  within("#user#{User.find_by_username(user).id}-search") do
    expect(page).to have_xpath("//img[contains(@src, \"missing.png\")]")
  end
end

Then /^I should see the "([^"]*)" profile picture for "([^"]*)"$/ do |image, user|
  within("#user#{User.find_by_username(user).id}-search") do
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
  expect(page).to have_css("#login-modal")
end

Then /^I should not see the login form$/ do
  expect(page).not_to have_css("#login-modal")
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

Then /^I should be redirected to Facebook again$/ do
  expect(URI.parse(current_url).path).to eq("users/auth/facebook")
end

Then /^I should be prompted to log in$/ do
  expect(page).to have_css("#login-modal")
end

Then /^I should not see the button to find friends from Facebook$/ do
  expect(page).not_to have_css("#facebook-friends-find")
end

Then /^I should see the button to find friends from Facebook$/ do
  expect(page).to have_css("#facebook-friends-find")
  expect(URI.parse(page.find("#facebook-friends-find")['href']).path).to eq(path_to("the find Facebook friends page"))
end

Then /^I should see the welcome message$/ do
  within(all('.alert-welcome').first) do
    expect(page).to have_content("Start by searching for battles and other users to follow")
  end
end

Then /^I should not see the welcome message$/ do
  expect(page).not_to have_css('.alert-welcome')
end
