RSpec.describe WorldwideOrganisationPresenter do
  let(:content_item) { ContentItem.new(GovukSchemas::Example.find("worldwide_organisation", example_name: "worldwide_organisation")) }

  let(:presenter) do
    described_class.new(content_item)
  end

  it "description of primary_role_person should have spaces between roles" do
    presenter = described_class.new(ContentItem.new({
      "details" => { "people_role_associations" => [
        {
          "person_content_id" => "person_1",
          "role_appointments" => [
            {
              "role_appointment_content_id" => "role_apppointment_1",
              "role_content_id" => "role_1",
            },
            {
              "role_appointment_content_id" => "role_apppointment_2",
              "role_content_id" => "role_2",
            },
          ],
        },
      ] },
      "links" => {
        "primary_role_person" => [
          {
            "content_id" => "person_1",
            "details" => { "image" => {} },
            "links" => {},
          },
        ],
        "role_appointments" => [
          {
            "content_id" => "role_apppointment_1",
            "details" => { "current" => true },
            "links" => {},
          },
          {
            "content_id" => "role_apppointment_2",
            "details" => { "current" => true },
            "links" => {},
          },
        ],
        "roles" => [
          {
            "content_id" => "role_1",
            "title" => "Example Role 1",
          },
          {
            "content_id" => "role_2",
            "title" => "Example Role 2",
          },
        ],
      },
    }))

    expect(presenter.person_in_primary_role[:description]).to eq("Example Role 1, Example Role 2")
  end

  it "description of people_in_non_primary_roles should have spaces between roles" do
    presenter = described_class.new(ContentItem.new({
      "details" => { "people_role_associations" => [
        {
          "person_content_id" => "person_1",
          "role_appointments" => [
            {
              "role_appointment_content_id" => "role_apppointment_1",
              "role_content_id" => "role_1",
            },
            {
              "role_appointment_content_id" => "role_apppointment_2",
              "role_content_id" => "role_2",
            },
          ],
        },
      ] },
      "links" => {
        "secondary_role_person" => [
          {
            "content_id" => "person_1",
            "details" => { "image" => {} },
            "links" => {},
          },
        ],
        "role_appointments" => [
          {
            "content_id" => "role_apppointment_1",
            "details" => { "current" => true },
            "links" => {},
          },
          {
            "content_id" => "role_apppointment_2",
            "details" => { "current" => true },
            "links" => {},
          },
        ],
        "roles" => [
          {
            "content_id" => "role_1",
            "title" => "Example Role 1",
          },
          {
            "content_id" => "role_2",
            "title" => "Example Role 2",
          },
        ],
      },
    }))

    expect(presenter.people_in_non_primary_roles.first[:description]).to eq("Example Role 1, Example Role 2")
  end

  it "#world_location_links returns the world locations as a joined sentence of links" do
    expected_links =
      "<a class=\"govuk-link\" href=\"/world/india/news\">India with translation</a> and " \
        "<a class=\"govuk-link\" href=\"/world/another-location/news\">Another location with translation</a>"

    expect(presenter.world_location_links).to eq(expected_links)
  end

  it "#world_location_links returns nil when world locations are empty" do
    content_item.content_store_response["links"].delete("world_locations")
    presenter = described_class.new(content_item)

    expect(presenter.world_location_links).to be_nil
  end

  it "#sponsoring_organisation_links returns the sponsoring organisations as sentence of links" do
    expected_links =
      "<a class=\"sponsoring-organisation govuk-link\" href=\"/government/organisations/foreign-commonwealth-development-office\">Foreign, Commonwealth &amp; Development Office</a> and " \
        "<a class=\"sponsoring-organisation govuk-link\" href=\"/government/organisations/department-for-business-and-trade\">Department for Business and Trade</a>"

    expect(presenter.sponsoring_organisation_links).to eq(expected_links)
  end

  it "#sponsoring_organisation_links returns nil when sponsoring organisations are empty" do
    content_item.content_store_response["links"].delete("sponsoring_organisations")
    presenter = described_class.new(content_item)

    expect(presenter.sponsoring_organisation_links).to be_nil
  end

  it "#social_media_links returns the social media accounts" do
    expect(presenter.social_media_accounts).to eq(content_item.content_store_response["details"]["social_media_links"])
  end

  it "#main_office returns nil when there is no main office" do
    content_item.content_store_response["links"].delete("main_office")

    presenter = described_class.new(content_item)

    expect(presenter.main_office).to be_nil
  end

  test "#home_page_offices returns an empty array when there are no home page offices" do
    content_item.content_store_response["links"].delete("home_page_offices")

    presenter = described_class.new(content_item)

    expect(presenter.home_page_offices).to eq([])
  end
end
