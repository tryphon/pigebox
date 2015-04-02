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

When /^a label "(.*?)" is created via UDP$/ do |name|
  # UDPSocket.new.send content, 0, current_box.ip_address, port
  socket = UDPSocket.new
  begin
    socket.send "label: #{name}", 0, current_box.ip_address, 9999
    message = socket.recvfrom(10)
    expect(message[0]).to eq("ACK")
  ensure
    socket.close
  end
end

def labels_with(text)
  current_box.get("sources/1/labels.json", query: { term: text })
end

Then /a label "([^"]*)" should exist/ do |label_name|
  expect(labels_with(label_name)).not_to be_empty
end

Then /a label "([^"]*)" should not exist/ do |label_name|
  expect(labels_with(label_name)).to be_empty
end
