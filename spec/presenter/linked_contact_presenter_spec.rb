RSpec.describe LinkedContactPresenter do
  let(:contact_content_item) { WorldwideOffice.new(GovukSchemas::Example.find("worldwide_office", example_name: "worldwide_office")).contact }

  it "#post_address returns nil when nil on the content item" do
    contact_content_item.content_store_response["details"]["post_addresses"] = nil

    presented_item = described_class.new(contact_content_item.content_store_response)

    expect(presented_item.post_address).to be_nil
  end

  it "#post_address returns the first post address from the content item as a formatted address" do
    expected_address =
      "<address class=\"govuk-body\"><p class=\"adr\">\n"\
      "<span class=\"fn\">British Embassy Manila</span><br />\n"\
      "<span class=\"street-address\">120 Upper McKinley Road, McKinley Hill</span> <span class=\"region\">Manila</span><br />\n"\
      "<span class=\"postal-code\">1634</span> <span class=\"locality\">Taguig City</span><br />\n"\
      "<span class=\"country-name\">Philippines</span>\n</p>\n</address>"

    presented_item = described_class.new(contact_content_item.content_store_response)

    expect(expected_address).to eq(presented_item.post_address)
  end

  it "#email returns nil when nil on the content item" do
    contact_content_item.content_store_response["details"]["email_addresses"] = nil

    presented_item = described_class.new(contact_content_item.content_store_response)

    expect(presented_item.email).to be_nil
  end

  it "#email returns the first email address from the content item" do
    presented_item = described_class.new(contact_content_item.content_store_response)

    expect(presented_item.email).to eq("ukinthephilippines@fco.gov.uk")
  end

  it "#contact_form_link returns nil when nil on the content item" do
    contact_content_item.content_store_response["details"]["contact_form_links"] = nil

    presented_item = described_class.new(contact_content_item.content_store_response)

    expect(presented_item.contact_form_link).to be_nil
  end

  it "#contact_form_link returns the contact form link from the content item" do
    presented_item = described_class.new(contact_content_item.content_store_response)

    expect(presented_item.contact_form_link).to eq("http://www.gov.uk/contact-consulate-manila")
  end

  it "#comments returns the contact description" do
    expected_comments =
      "<p class=\"govuk-body\">24/7 consular support is available by telephone for all routine enquiries and emergencies. "\
      "Please call +63 (02) 8 858 2200 / +44 20 7136 6857. <br/><br/>Public access to the embassy is by appointment only. "\
      "Please visit https://www.gov.uk/world/philippines or call +63 (02) 8 858 2200.</p>"

    presented_item = described_class.new(contact_content_item.content_store_response)

    expect(expected_comments).to eq(presented_item.comments)
  end
end
