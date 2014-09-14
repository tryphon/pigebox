Given /^a label "(.*?)" is created$/ do |name|
  visit '/sources/1/labels/new'
  fill_in 'Name', :with => name
  click_button 'Create'
end

When /^(\d+) labels are created$/ do |count|
  count.to_i.times do |n|
    current_box.post "sources/1/labels.json", body: { label: { name: "Label #{n}" }}
  end
end

Then /a label "([^"]*)" should exist/ do |label_name|
  current_box.get("sources/1/labels.json", query: { term: label_name }).should_not be_empty
end

Then /a label "([^"]*)" should not exist/ do |label_name|
  current_box.get("sources/1/labels.json", query: { term: label_name }).should be_empty
end
