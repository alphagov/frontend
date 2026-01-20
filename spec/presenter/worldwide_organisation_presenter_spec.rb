RSpec.describe WorldwideOrganisationPresenter do
  subject(:worldwide_organisation_presenter) { described_class.new(content_item) }

  let(:content_item) { ContentItem.new(content_store_response) }
  let(:content_store_response) { GovukSchemas::Example.find("worldwide_organisation", example_name: "worldwide_organisation") }

  describe "#person_in_primary_role" do
    context "with primary role person" do
      let(:content_store_response) do
        {
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
        }
      end

      it "has spaces between roles in primary_role_person description" do
        expect(worldwide_organisation_presenter.person_in_primary_role[:description]).to eq("Example Role 1, Example Role 2")
      end

      it "#show_our_people_section? returns true" do
        expect(worldwide_organisation_presenter.show_our_people_section?).to eq(worldwide_organisation_presenter.person_in_primary_role)
      end
    end
  end

  it "description of people_in_non_primary_roles should have spaces between roles" do
    worldwide_organisation_presenter = described_class.new(ContentItem.new({
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

    expect(worldwide_organisation_presenter.people_in_non_primary_roles.first[:description]).to eq("Example Role 1, Example Role 2")
  end

  it "#show_our_people_section? returns true when people_in_non_primary_roles exist" do
    worldwide_organisation_presenter = described_class.new(ContentItem.new({
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

    expect(worldwide_organisation_presenter.show_our_people_section?).to be(true)
  end

  it "#show_our_people_section? returns false when no people in primary or non primary roles are present" do
    content_item.content_store_response["links"].delete("primary_role_person")
    content_item.content_store_response["links"].delete("secondary_role_person")
    content_item.content_store_response["links"].delete("office_staff")

    described_class.new(content_item)
    expect(worldwide_organisation_presenter.show_our_people_section?).to be(false)
  end

  it "#world_location_links returns the world locations as a joined sentence of links" do
    expected_links =
      '<a class="govuk-link" href="/world/india/news">India with translation and the UK</a> and <a class="govuk-link" href="/world/another-location/news">Another location with translation and the UK</a>'

    expect(worldwide_organisation_presenter.world_location_links).to eq(expected_links)
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

    expect(worldwide_organisation_presenter.sponsoring_organisation_links).to eq(expected_links)
  end

  it "#sponsoring_organisation_links returns nil when sponsoring organisations are empty" do
    content_item.content_store_response["links"].delete("sponsoring_organisations")
    described_class.new(content_item)

    expect(worldwide_organisation_presenter.sponsoring_organisation_links).to be_nil
  end

  it "#logo returns the logo" do
    expect(worldwide_organisation_presenter.logo).to eq(content_store_response["details"]["logo"])
  end

  it "#logo returns an empty array if there is no logo" do
    content_item.content_store_response["details"].delete("logo")
    described_class.new(content_item)
    expect(worldwide_organisation_presenter.logo).to eq([])
  end

  it "#social_media_links returns the social media accounts" do
    expect(worldwide_organisation_presenter.social_media_accounts).to eq(content_store_response["details"]["social_media_links"])
  end

  it "#social_media_links returns an empty array if there are no social media accounts" do
    content_item.content_store_response["details"].delete("social_media_links")
    described_class.new(content_item)
    expect(worldwide_organisation_presenter.social_media_accounts).to eq([])
  end

  describe "#main_office" do
    context "when there are is no main office" do
      let(:content_item) do
        content_store_response.tap { |response| response["links"].delete("main_office") }
        ContentItem.new(content_store_response)
      end

      it "returns nil" do
        presenter = described_class.new(content_item)
        expect(presenter.main_office).to be_nil
      end
    end
  end

  describe "#home_page_offices" do
    context "when there are no home page offices" do
      let(:content_item) do
        content_store_response.tap { |response| response["links"].delete("home_page_offices") }
        ContentItem.new(content_store_response)
      end

      it "returns an empty array" do
        expect(worldwide_organisation_presenter.home_page_offices).to eq([])
      end
    end
  end
end
