include ActionDispatch::TestProcess

### UTILITY METHODS ###

def create_path(image_name)
  filepath = Rails.root.join('spec', 'fixtures', 'images', image_name).to_path
  if filepath.match(/^[A-Z]:\//)
    filepath.gsub!(/\//, "\\")
  end
  return filepath
end

def attach_option_picture(image_name)
  if image_name != ""
    filepath = create_path(image_name)
    page.execute_script("$('.upload_picture').show();")
    attach_file(find(".upload_picture")[:id], filepath)
    page.execute_script("$('.upload_picture').hide();")
  end
end

### GIVEN ###

Given /^I am logged on my home page$/ do
  create_user("myself", "myself@email.com", "secretpassword")
  sign_in("myself@email.com", "secretpassword")
  visit root_path
end

Given /^I am signed in on my home page$/ do
  logout(:user)
  sign_in("myself@email.com", "secretpassword")
  visit root_path
end

Given /^current time is (.+)$/ do |time|
  Timecop.travel(Time.parse(time))
end

Given /^the page size is (\d+)x(\d+)$/ do |width, height|
  window = Capybara.current_session.driver.browser.manage.window
  window.resize_to(width, height)
end


### WHEN ###

When /^I go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^I am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  click_link(link)
end

When /^(?:|I )follow "([^"]*)" within "([^"]*)"$/ do |link, scope|
  within("div[id=#{scope}]") do
    click_link(link)
  end
end

When /^(?:|I )follow the (\d+)(?:st|nd|rd|th) "([^"]*)"$/ do |num, name|
  all("a.#{name}")[num.to_i - 1].click
end

When /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button)
end

When /^(?:|I )click "([^"]*)"$/ do |button|
  click_button(button)
end

When /^I confirm popup$/ do
  page.driver.browser.switch_to.alert.accept
end

When /^I dismiss popup$/ do
  page.driver.browser.switch_to.alert.dismiss
end

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value)
end

When /^(?:|I )fill in the (\d+)(?:st|nd|rd|th) "([^"]*)" with "([^"]*)"$/ do |num, name, value|
  find(:xpath, ".//form/input[@name='#{name}'][#{num}]").set(value)
end

When /^(?:|I )erase "([^"]*)"$/ do |field|
  fill_in(field, :with => "")
end

When /^(?:|I )select "([^"]*)" from "([^"]*)"$/ do |value, field|
  select(value, :from => field)
end

When /^(?:|I )select datetime "([^ ]*) ([^ ]*) ([^ ]*) - ([^:]*):([^"]*)" as the "([^"]*)"$/ do |year, month, day, hour, minute, field|
  fill_in(field, :with => "#{day}/#{month}/#{year} #{hour}:#{minute}")
end

When /^(?:|I )check "([^"]*)"$/ do |field|
  check(field)
end

When /^(?:|I )uncheck "([^"]*)"$/ do |field|
  uncheck(field)
end

When /^(?:|I )choose "([^"]*)"$/ do |field|
  choose(field)
end

When /^I scroll to the bottom of the page$/ do
  page.execute_script("window.scrollBy(0,10000)")
end

When /^I scroll to the top of the page$/ do
  page.execute_script("window.scrollBy(0,-10000)")
end


### THEN ###

Then /^(?:|I )should be on (.+)$/ do |page_name|
  expect(URI.parse(current_url).path).to eq(path_to(page_name))
end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  expect(page).to have_content(text)
end

Then /^(?:|I )should not see "([^"]*)"$/ do |text|
  expect(page).to have_no_content(text)
end

Then /^(?:|I )should see:/ do |text_table|
  text_table.hashes.each do |text|
    text.keys.each do |key|
      step %Q{I should see "#{text[key]}"}
    end
  end
end

Then /^(?:|I )should not see:/ do |text_table|
  text_table.hashes.each do |text|
    text.keys.each do |key|
      step %Q{I should not see "#{text[key]}"}
    end
  end
end

Then /^I should see "([^"]*)" after "([^"]*)"$/ do |e1, e2|
  assert page.body =~ /#{e2}.*#{e1}/m
end

Then /^I should not see "([^"]*)" after "([^"]*)"$/ do |e1, e2|
  assert(not(page.body =~ /#{e2}.*#{e1}/m))
end

Then /^I should see the image "(.+)"$/ do |image|
  expect(page).to have_xpath("//img[contains(@src, \"#{image}\")]")
end

Then /^I should not see the image "(.+)"$/ do |image|
  expect(page).not_to have_xpath("//img[contains(@src, \"#{image}\")]")
end

Then /^the button "([^"]*)" should be inactive$/ do |button|
  # When a button is inactive, then it becomes "invisible"
  begin
    element = find_button(button)
  rescue Capybara::ElementNotFound
    # In Capybara 0.4+ #find_button raises an error instead of returning nil
  end
  expect(element).to be_nil
end

Then /^"([^\"]*)" should link to (.+)$/ do |link_text, page_name|
  expect(URI.parse(page.find_link(link_text)['href']).path).to eq(path_to(page_name))
end

Then /^"([^\"]*)" within "([^\"]*)" should link to (.+)$/ do |link_text, container, page_name|
  within(container) do
    expect(URI.parse(page.find_link(link_text)['href']).path).to eq(path_to(page_name))
  end
end

Then /^I should not see a link to (.+)$/ do |page_name|
  assert not(page.body =~ /#{path_to(page_name)}/m)
end

Then /^I should see "(.*?)" css element$/ do |element|
  expect(page).to have_css("#{element}")
end

Then /^I should not see "(.*?)" css element$/ do |element|
  expect(page).not_to have_css("#{element}")
end

Then /^(?:|I )should see "([^"]*)" within "([^"]*)"$/ do |text, scope|
  within("div[id=#{scope}]") do
    expect(page).to have_content(text)
  end
end

Then /^(?:|I )should not see "([^"]*)" within "([^"]*)"$/ do |text, scope|
  within("div[id=#{scope}]") do
    expect(page).to have_no_content(text)
  end
end

Then /^I wait (\d+) second(?:|s)$/ do |time|
  sleep time.to_f
end

