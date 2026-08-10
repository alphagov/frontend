RSpec.describe PersonPresenter do
  subject(:presenter) { described_class.new(person) }

  let(:content_store_response) do
    {
      "title" => "Rufus Scrimgeour",
      "description" => "Minister for Magic",
      "base_path" => "/government/people/rufus-scrimgeour",
      "locale" => "en",
      "details" => {},
      "links" => {
        "role_appointments" => [
          {
            "details" => {
              "current" => true,
              "person_appointment_order" => 1,
            },
            "links" => {
              "role" => [
                {
                  "title" => "Minister for Magic",
                  "base_path" => "/government/ministers/minister-for-magic",
                  "document_type" => "ministerial_role",
                  "details" => { "body" => "<p>Leads the Ministry.</p>" },
                  "links" => { "ordered_parent_organisations" => [] },
                },
              ],
            },
          },
          {
            "details" => {
              "current" => false,
              "person_appointment_order" => 2,
              "started_on" => "2014-06-01T00:00:00+00:00",
              "ended_on" => "2016-07-31T00:00:00+00:00",
            },
            "links" => {
              "role" => [
                {
                  "title" => "Head of the Auror Office",
                  "base_path" => "/government/ministers/head-of-the-auror-office",
                  "document_type" => "role",
                  "details" => { "body" => "<p>Led the Auror Office.</p>" },
                  "links" => { "ordered_parent_organisations" => [] },
                },
              ],
            },
          },
        ],
      },
    }
  end
  let(:person) { Person.new(content_store_response) }

  describe "#current_roles_title" do
    it "returns the current role titles as a sentence" do
      expect(presenter.current_roles_title).to eq("Minister for Magic")
    end
  end

  describe "#page_title_options" do
    it "uses current roles as the heading context" do
      expect(presenter.page_title_options).to include(
        title: "Rufus Scrimgeour",
        context: "Minister for Magic",
        context_locale: "en",
      )
    end
  end

  describe "#previous_roles_items" do
    it "formats previous appointments for the document list component" do
      expect(presenter.previous_roles_items).to eq([
        {
          link: {
            text: "Head of the Auror Office",
            path: "/government/ministers/head-of-the-auror-office",
          },
          metadata: {
            appointment_duration: "2014 to 2016",
          },
        },
      ])
    end
  end

  describe "#contents" do
    it "returns the contents" do
      search_api_results = {
        "results" => [
          {
            link: "/news/my-item",
            title: "Winner of Jubilee rug design",
            public_timestamp: "2025-12-01T00:00:01Z",
            content_store_document_type: "press_release",
          },
        ],
      }
      stub_request(:get, "#{Plek.new.find('search-api')}/search.json?count=10&fields%5B%5D=content_store_document_type&fields%5B%5D=link&fields%5B%5D=public_timestamp&fields%5B%5D=title&filter_people=rufus-scrimgeour&order=-public_timestamp&reject_content_purpose_supergroup=other").to_return(status: 200, body: search_api_results.to_json)

      expect(presenter.contents).to eq([
        {
          href: "#biography",
          text: "Biography",
        },
        {
          href: "#current-roles",
          text: "Role",
        },
        {
          href: "#previous-roles",
          text: "Previous roles",
        },
        {
          href: "#announcements",
          text: "Announcements",
        },
      ])
    end
  end
end
