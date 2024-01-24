require "integration_test_helper"

class TransactionTest < ActionDispatch::IntegrationTest
  include SchemaOrgHelpers
  include GovukAbTesting::MinitestHelpers

  context "a transaction with all the optional things" do
    setup do
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
          introductory_paragraph: "This is the introduction to carrots
          <h2>Next bit</h2>If you'd like some carrots, you need to prove that you're not a rabbit",
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

    should "render the main information" do
      visit "/carrots"

      assert_equal 200, page.status_code

      within "head", visible: :all do
        assert page.has_selector?("title", text: "Carrots - GOV.UK", visible: false)
        assert_not page.has_selector?("meta[name='robots']", visible: false)
      end

      within "#content" do
        within ".gem-c-title" do
          assert_has_component_title "Carrots"
        end

        within ".article-container" do
          within "section.intro" do
            assert page.has_selector?(".get-started-intro", text: "This is the introduction to carrots")

            assert_has_button_as_link(
              "Eat Carrots Now",
              href: "http://carrots.example.com",
              start: true,
              rel: "external",
            )

            assert page.has_content?("Carrotworld")
          end
        end
      end

      within(".gem-c-warning-text") do
        assert page.has_content?("CarrotServe will be offline next week.")
      end
    end

    should "present the FAQ schema correctly until voting closes" do
      setup_register_to_vote

      when_voting_is_open do
        visit "/register-to-vote"
        faq_schema = find_schema_of_type("FAQPage")

        assert_equal SchemaOrgHelpers::REGISTER_TO_VOTE_SCHEMA, faq_schema
      end
    end

    should "not present the custom FAQ schema once voting has closed" do
      setup_register_to_vote

      when_voting_is_closed do
        visit "/register-to-vote"
        faq_schema = find_schema_of_type("FAQPage")

        assert_nil faq_schema
      end
    end

    should "contain GovernmentService schema.org information" do
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

      assert_equal expected_service, service_schema
    end
  end

  context "jobsearch page" do
    should "render ok" do
      content_store_has_example_item("/jobsearch", schema: "transaction", example: "jobsearch")
      visit "/jobsearch"

      assert_equal 200, page.status_code
      assert_has_button_as_link(
        "Start now",
        href: "https://jobsearch.direct.gov.uk/JobSearch/PowerSearch.aspx",
      )
    end
  end

  context "start page which should have cross domain analytics" do
    should "include cross domain analytics javascript" do
      content_store_has_example_item("/foo", schema: "transaction", example: "transaction")
      visit "/foo"

      assert_equal 200, page.status_code
      assert_has_button_as_link(
        "Start now",
        rel: "external",
        href: "http://cti.voa.gov.uk/cti/inits.asp",
        start: true,
        data_attributes: {
          "module" => "cross-domain-tracking",
          "tracking-code" => "UA-12345-6",
          "tracking-name" => "transactionTracker",
        },
      )
    end
  end

  context "start page format which shouldn't have cross domain analytics" do
    should "not include cross domain analytics javascript" do
      content_store_has_example_item("/foo", schema: "transaction", example: "jobsearch")
      visit "/foo"

      assert_equal 200, page.status_code
      assert_has_button_as_link(
        "Start now",
        rel: "external",
        start: true,
        href: "https://jobsearch.direct.gov.uk/JobSearch/PowerSearch.aspx",
      )
    end
  end

  context "locale is 'cy'" do
    setup do
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

    should "render start button text 'Dechrau nawr'" do
      visit "/cymraeg"

      within ".article-container" do
        within "section.intro" do
          assert_has_button_as_link(
            "Dechrau nawr",
            rel: "external",
            start: true,
            href: "http://cymraeg.example.com",
          )
        end
      end
    end
  end

  context "a transaction has variants" do
    should "render correct content including robots meta tag" do
      content_store_has_example_item("/council-tax-bands-2", schema: "transaction", example: "transaction-with-variants")
      visit "/council-tax-bands-2/council-tax-bands-2-staging"

      assert_equal 200, page.status_code
      assert_has_button_as_link(
        "Start now",
        href: "http://cti-staging.voa.gov.uk/cti/inits.asp",
      )

      within ".gem-c-title" do
        assert_has_component_title "Check your Council Tax band (staging)"
      end

      within "head", visible: :all do
        assert page.has_selector?("meta[name='robots'][content='noindex, nofollow']", visible: false)
      end
    end
  end

  context "when hmrc temporary AB testing is live" do
    setup do
      content_store_has_example_item("/self-assessment-ready-reckoner", schema: "transaction", example: "transaction")
    end

    should "not add any additional content for the A variant" do
      with_variant ReadyReckonerVideoTest2: "A" do
        visit "/self-assessment-ready-reckoner"
        assert page.has_no_content?("Watch this video to find out how a budget payment plan can help you pay your tax bill on time")
      end
    end

    should "add an additional paragraph with link to video for the B variant" do
      with_variant ReadyReckonerVideoTest2: "B" do
        visit "/self-assessment-ready-reckoner"
        assert page.has_content?("Watch this video to find out how a budget payment plan can help you pay your tax bill on time")
      end
    end

    should "not add any additional content for the Z variant" do
      with_variant ReadyReckonerVideoTest2: "Z" do
        visit "/self-assessment-ready-reckoner"
        assert page.has_no_content?("Watch this video to find out how a budget payment plan can help you pay your tax bill on time")
      end
    end
  end
end
