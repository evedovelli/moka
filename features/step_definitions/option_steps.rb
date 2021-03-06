include ActionDispatch::TestProcess

### THEN ###

Then /^the size of options should be small$/ do
  all(".option-sizeable").each do |option|
    expect(option["class"]).to match("span2")
  end
end

Then /^the size of options should be medium$/ do
  all(".option-sizeable").each do |option|
    expect(option["class"]).to match("span3")
  end
end

Then /^the size of options should be big$/ do
  all(".option-sizeable").each do |option|
    expect(option["class"]).to match("span4")
  end
end

Then /^I should not see offset for first option$/ do
  expect(all(".option-offsetable")[0]["class"]).to match("offset0")
end

Then /^I should see a small offset for first option$/ do
  expect(all(".option-offsetable")[0]["class"]).to match("offset1")
end

Then /^I should see a big offset for first option$/ do
  expect(all(".option-offsetable")[0]["class"]).to match("offset2")
end

Then /^the size of option forms should be small$/ do
  all(".option-form-sizeable").each do |option|
    expect(option["class"]).to match("span2")
  end
end

Then /^the size of option forms should be medium$/ do
  all(".option-form-sizeable").each do |option|
    expect(option["class"]).to match("span3")
  end
end

Then /^the size of option forms should be big$/ do
  all(".option-form-sizeable").each do |option|
    expect(option["class"]).to match("span4")
  end
end

Then /^I should not see offset for first option form$/ do
  expect(all(".option-form-offsetable")[0]["class"]).to match("offset0")
end

Then /^I should see a small offset for first option form$/ do
  expect(all(".option-form-offsetable")[0]["class"]).to match("offset1")
end

Then /^I should see a big offset for first option form$/ do
  expect(all(".option-form-offsetable")[0]["class"]).to match("offset2")
end
