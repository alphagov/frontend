Given /^there are documents tagged to a specialist sector topic$/ do
  stub_specialist_sector_topics
end

When /^I view the browse page for that topic$/ do
  visit_specialist_sector_topic
end

Then /^I see the documents grouped by document format$/ do
  assert_presence_of_grouped_specialist_sector_content
end

Then /^I don't see headings for formats with no documents$/ do
  assert_no_headings_for_empty_format_groups
end


