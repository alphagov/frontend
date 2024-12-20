RSpec.describe "Transaction" do
  include SchemaOrgHelpers

  context "a transaction with all the optional things" do
    before do
      @payload = {
        analytics_identifier: nil,
        base_path: "/carrots",
        content_id: "d6d6caaf-77db-47e1-8206-30cd4f3d0e3f",
        document_type: "transaction",
        first_published_at: "2016-02-29T09:24:10.000+00:00",
        locale: "en",
        phase: "beta",
        public_updated_at: "2012-10-22T12:49:50.000+00:00",
        publishing_app: "publisher",
        rendering_app: "frontend",
        schema_name: "transaction",
        title: "Carrots",
        updated_at: "2012-10-22T12:30:33.483Z",
        withdrawn_notice: {},
        links: {},
        description: "Descriptive carrots text.",
        details: {
          introductory_paragraph: "This is the introduction to carrots\n          <h2>Next bit</h2>If you'd like some carrots, you need to prove that you're not a rabbit",
          transaction_start_link: "http://carrots.example.com",
          will_continue_on: "Carrotworld",
          start_button_text: "Eat Carrots Now",
          what_you_need_to_know: "Includes carrots",
          downtime_message: "CarrotServe will be offline next week.",
        },
        external_related_links: [],
      }
      stub_content_store_has_item("/carrots", @payload)
    end

    it "renders the main information" do
      visit "/carrots"

      expect(page.status_code).to eq(200)
      within("head", visible: :all) do
        expect(page).to have_selector("title", text: "Carrots - GOV.UK", visible: false)
        expect(page).not_to have_selector("meta[name='robots']", visible: false)
      end

      within("#content") do
        within("h1.gem-c-heading") { expect(page).to have_title("Carrots") }
        within(".article-container") do
          within("section.intro") do
            expect(page).to have_selector(".get-started-intro", text: "This is the introduction to carrots")
            expect(page).to have_button_as_link("Eat Carrots Now", href: "http://carrots.example.com", start: true, rel: "external")
            expect(page).to have_content("Carrotworld")
          end
        end
      end

      within(".gem-c-warning-text") do
        expect(page).to have_content("CarrotServe will be offline next week.")
      end
    end

    it "contains GovernmentService schema.org information" do
      carrot_service_with_org = @payload.merge(
        links: {
          organisations: [
            {
              title: "Department for Carrots",
              web_url: "https://www.gov.uk/department-for-carrots",
            },
          ],
        },
      )
      stub_content_store_has_item("/carrots", carrot_service_with_org)
      visit "/carrots"
      service_schema = find_schema_of_type("GovernmentService")
      expected_service = {
        "@context" => "http://schema.org",
        "@type" => "GovernmentService",
        "name" => "Carrots",
        "description" => "Descriptive carrots text.",
        "url" => "http://www.dev.gov.uk/carrots",
        "provider" => [
          {
            "@type" => "GovernmentOrganization",
            "name" => "Department for Carrots",
            "url" => "https://www.gov.uk/department-for-carrots",
          },
        ],
      }
      expect(service_schema).to eq(expected_service)
    end
  end

  context "jobsearch page" do
    it "renders ok" do
      content_store_has_example_item("/jobsearch", schema: "transaction", example: "jobsearch")
      visit "/jobsearch"

      expect(page.status_code).to eq(200)
      expect(page).to have_button_as_link("Start now", href: "https://jobsearch.direct.gov.uk/JobSearch/PowerSearch.aspx")
    end
  end

  context "start page which should have cross domain analytics" do
    it "includes cross domain analytics javascript" do
      content_store_has_example_item("/foo", schema: "transaction", example: "transaction")
      visit "/foo"

      expect(page.status_code).to eq(200)
      expect(page).to have_button_as_link("Start now", rel: "external", href: "http://cti.voa.gov.uk/cti/inits.asp", start: true)
    end
  end

  context "start page format which shouldn't have cross domain analytics" do
    it "does not include cross domain analytics javascript" do
      content_store_has_example_item("/foo", schema: "transaction", example: "jobsearch")
      visit "/foo"

      expect(page.status_code).to eq(200)
      expect(page).to have_button_as_link("Start now", rel: "external", start: true, href: "https://jobsearch.direct.gov.uk/JobSearch/PowerSearch.aspx")
    end
  end

  context "locale is 'cy'" do
    before do
      @payload = {
        base_path: "/cymraeg",
        content_id: "d6d6caaf-77db-47e1-8206-30cd4f3d0e3f",
        document_type: "transaction",
        locale: "cy",
        publishing_app: "publisher",
        rendering_app: "frontend",
        schema_name: "transaction",
        title: "Cymraeg",
        description: "Cynnwys Cymraeg",
        details: {
          transaction_start_link: "http://cymraeg.example.com",
          start_button_text: "Start now",
        },
      }
      stub_content_store_has_item("/cymraeg", @payload)
    end

    it "renders start button text 'Dechrau nawr'" do
      visit "/cymraeg"

      within(".article-container") do
        within("section.intro") do
          expect(page).to have_button_as_link("Dechrau nawr", rel: "external", start: true, href: "http://cymraeg.example.com")
        end
      end
    end
  end

  context "a transaction has variants" do
    it "renders correct content including robots meta tag" do
      content_store_has_example_item("/council-tax-bands-2", schema: "transaction", example: "transaction-with-variants")
      visit "/council-tax-bands-2/council-tax-bands-2-staging"

      expect(page.status_code).to eq(200)
      expect(page).to have_button_as_link("Start now", href: "http://cti-staging.voa.gov.uk/cti/inits.asp")

      within("h1.gem-c-heading") do
        expect(page).to have_title("Check your Council Tax band (staging)")
      end

      within("head", visible: :all) do
        expect(page).to have_selector("meta[name='robots'][content='noindex, nofollow']", visible: false)
      end
    end
  end
end
