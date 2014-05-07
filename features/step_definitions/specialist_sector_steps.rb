Given /^there are documents tagged to a specialist sector topic$/ do
  stub_specialist_sector_topics
end

When /^I view the browse page for that topic$/ do
  visit_specialist_sector_topic
end

Then /^I see the specialist sector documents$/ do
  assert_presence_of_specialist_sector_content
end
