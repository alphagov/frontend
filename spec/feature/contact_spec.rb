require "gds_api/test_helpers/support_api"
require "gds_zendesk/test_helpers"

def i_should_be_on(path_with_query)
  expected = URI.parse(path_with_query)
  current = URI.parse(current_url)
  expect(current.path).to eq(expected.path)
  expect(Rack::Utils.parse_query(current.query)).to eq(Rack::Utils.parse_query(expected.query))
end

def fill_in_valid_contact_details_and_description
  fill_in "Your name", with: "test name"
  fill_in "Your email address", with: "a@a.com"
  fill_in "textdetails", with: "test text details"
end

def contact_submission_should_be_successful
  click_on "Send message"
  i_should_be_on "/contact/govuk/thankyou"
  expect(page).to have_content("Your message has been sent")
end

def anonymous_submission_should_be_successful
  click_on "Send message"
  i_should_be_on "/contact/govuk/anonymous-feedback/thankyou"
  expect(page).to have_content("Thank you for contacting GOV.UK")
end

def response_contains(request, field, expected_value)
  response = JSON.parse(request.body)
  raw_body = response["ticket"]["comment"]["body"]
  actual_value = raw_body.match(/#{Regexp.quote(field)}\n([^\[]+)/)
  actual_value = actual_value[1].strip unless actual_value.nil?
  actual_value == expected_value
end

RSpec.describe "Contact", type: :feature do
  include GdsApi::TestHelpers::SupportApi
  include GDSZendesk::TestHelpers

  before do
    self.valid_zendesk_credentials = ZENDESK_CREDENTIALS
  end

  it "should display an index page" do
    visit "/contact"
    expect(page).to have_title "Find contact details for services - GOV.UK"
  end

  it "should let the user submit a request with contact details" do
    zendesk_has_user(email: "a@a.com", suspended: false)
    body = "{\"ticket\":{\"subject\":\"Named contact\",\"tags\":[\"public_form\",\"named_contact\"],\"priority\":\"normal\",\"comment\":{\"body\":\"[Requester]\\ntest name <a@a.com>\\n\\n[Details]\\ntest text details\\n\\n[Link]\\n\\n\\n[Referrer]\\n\\n\\n[User agent]\\n\\n\\n[JavaScript Enabled]\\nfalse\\n\"},\"requester\":{\"name\":\"test name\",\"email\":\"a@a.com\"}}}"

    stub_post = stub_request(:post, "https://govuk.zendesk.com/api/v2/tickets")
      .with(
        body:,
        headers: { "Content-Type" => "application/json" },
      ).to_return(status: 200, body: "", headers: {})

    visit "/contact/govuk"
    expect(page).to have_title "Contact GOV.UK"

    choose "location-0" # Selects the 'The whole site' radio button
    fill_in_valid_contact_details_and_description
    contact_submission_should_be_successful

    assert_requested(stub_post)
  end

  it "should let the user submit an anonymous request" do
    stub_post = stub_support_api_long_form_anonymous_contact_creation(
      details: "test text details",
      link: nil,
      user_specified_url: nil,
      javascript_enabled: false,
      user_agent: nil,
      referrer: nil,
      url: "#{Plek.new.website_root}/contact/govuk",
      path: "/contact/govuk",
    )

    visit "/contact/govuk"

    choose "location-0" # Selects the 'The whole site' radio button
    fill_in "textdetails", with: "test text details"
    anonymous_submission_should_be_successful

    assert_requested(stub_post)
  end

  it "should not proceed if the user hasn't filled in all required fields" do
    zendesk_has_user(email: "a@a.com", suspended: false)
    visit "/contact/govuk"

    choose "location-0" # Selects the 'The whole site' radio button
    fill_in "Your name", with: "test name"
    fill_in "Your email address", with: "a@a.com"
    click_on "Send message"

    i_should_be_on "/contact/govuk"

    expect(find_field("Your name").value).to eq "test name"
    expect(find_field("Your email address").value).to eq "a@a.com"

    no_post_calls_should_have_been_made
  end

  it "should not let the user submit a request with email without name" do
    zendesk_has_user(email: "a@a.com", suspended: false)
    visit "/contact/govuk"

    choose "location-0" # Selects the 'The whole site' radio button
    fill_in "Your email address", with: "a@a.com"
    fill_in "textdetails", with: "test text details"
    click_on "Send message"

    i_should_be_on "/contact/govuk"

    expect(find_field("Your email address").value).to eq "a@a.com"
    expect(find_field("textdetails").value).to eq "test text details"

    no_post_calls_should_have_been_made
  end

  it "should not let the user submit a request with name without email" do
    visit "/contact/govuk"

    choose "location-0" # Selects the 'The whole site' radio button
    fill_in "Your name", with: "test name"
    fill_in "textdetails", with: "test text details"
    click_on "Send message"

    i_should_be_on "/contact/govuk"

    expect(find_field("Your name").value).to eq "test name"
    expect(find_field("textdetails").value).to eq "test text details"

    no_post_calls_should_have_been_made
  end

  it "should let the user submit a request with a link" do
    zendesk_has_user(email: "a@a.com", suspended: false)
    stub_zendesk_ticket_creation

    visit "/contact/govuk"

    choose "location-1" # Selects the 'A specific page' radio button
    fill_in_valid_contact_details_and_description
    fill_in "link", with: "some url"
    click_on "Send message"

    i_should_be_on "/contact/govuk/thankyou"

    expect(page).to have_content("Your message has been sent, and the team will get back to you to answer any questions as soon as possible.")

    assert_requested(:post, %r{/tickets}) do |request|
      response_contains(request, "[Link]", "some url")
    end
  end

  it "should escape user malicious user input when rendering it back to the user" do
    visit "/contact/govuk"
    malicious_input = "<script>alert(0)</script>"

    choose "location-0" # # Selects the 'The whole site' radio button
    fill_in "Your name", with: malicious_input
    fill_in "Your email address", with: malicious_input
    fill_in "textdetails", with: malicious_input
    click_on "Send message"

    # submission isn't accepted because email address is invalid
    i_should_be_on "/contact/govuk"

    expect(page.html).to include("&lt;script&gt;alert(0)&lt;/script&gt;")
    expect(page.html).not_to include(malicious_input)

    no_post_calls_should_have_been_made
  end

  it "should have the GA4 form tracker on the form" do
    zendesk_has_user(email: "a@a.com", suspended: false)
    visit "/contact/govuk"

    expect(page).to have_selector(".contact-form[data-module=ga4-form-tracker]")

    form = page.first(".contact-form")
    ga4_data = JSON.parse(form["data-ga4-form"])

    expect(ga4_data["event_name"]).to eq "form_response"
    expect(ga4_data["type"]).to eq "contact"
    expect(ga4_data["section"]).to eq "What's it to do with?"
    expect(ga4_data["action"]).to eq "send message"
    expect(ga4_data["tool_name"]).to eq "Contact GOV.UK"
  end

  it "should have the GA4 auto tracker on the thank you pages" do
    visit "/contact/govuk/anonymous-feedback/thankyou"

    expect(page).to have_selector("p[data-module=ga4-auto-tracker]")

    ga4_auto_element = page.first("p[data-module=ga4-auto-tracker]")
    ga4_data = JSON.parse(ga4_auto_element["data-ga4-auto"])

    title = "Thank you for contacting GOV.UK"

    expect(ga4_data["event_name"]).to eq "form_complete"
    expect(ga4_data["type"]).to eq "contact"
    expect(ga4_data["text"]).to eq title
    expect(ga4_data["action"]).to eq "complete"
    expect(ga4_data["tool_name"]).to eq "Contact GOV.UK"
    expect(ga4_data["section"]).to eq title

    visit "/contact/govuk/thankyou"

    expect(page).to have_selector("p[data-module=ga4-auto-tracker]")

    ga4_auto_element = page.first("p[data-module=ga4-auto-tracker]")
    ga4_data = JSON.parse(ga4_auto_element["data-ga4-auto"])

    expect(ga4_data["event_name"]).to eq "form_complete"
    expect(ga4_data["type"]).to eq "contact"
    expect(ga4_data["text"]).to eq "Your message has been sent, and the team will get back to you to answer any questions as soon as possible."
    expect(ga4_data["action"]).to eq "complete"
    expect(ga4_data["tool_name"]).to eq "Contact GOV.UK"
    expect(ga4_data["section"]).to eq title
  end

  it "should have the GA4 auto tracker on form error" do
    visit "/contact/govuk"

    choose "location-1" # Selects the 'A specific page' radio button
    fill_in "Your name", with: ""
    fill_in "Your email address", with: "boba.com"
    fill_in "textdetails", with: ""
    fill_in "link", with: ""
    click_on "Send message"

    i_should_be_on "/contact/govuk"

    ga4_auto_element = page.first("form div[data-module=ga4-auto-tracker]")
    ga4_data = JSON.parse(ga4_auto_element["data-ga4-auto"])

    expect(ga4_data["event_name"]).to eq "form_error"
    expect(ga4_data["action"]).to eq "error"
    expect(ga4_data["type"]).to eq "contact"
    expect(ga4_data["text"]).to eq "The link field cannot be empty, The message field cannot be empty, The email address must be valid, The name field cannot be empty"
    expect(ga4_data["section"]).to eq "What's it to do with?, What are the details?, If you want a reply (optional), If you want a reply (optional)"
    expect(ga4_data["tool_name"]).to eq "Contact GOV.UK"
  end
end
