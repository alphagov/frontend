require "integration_test_helper"

class TransactionTest < ActionDispatch::IntegrationTest
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

      content_store_has_item("/carrots", @payload)
    end

    should "render the main information" do
      visit "/carrots"

      assert_equal 200, page.status_code

      within "head", visible: :all do
        assert page.has_selector?("title", text: "Carrots - GOV.UK", visible: false)
        assert_not page.has_selector?("meta[name='robots']", visible: false)
      end

      within "#content" do
        within "header" do
          assert_has_component_title "Carrots"
        end

        within ".article-container" do
          within "section.intro" do
            assert page.has_selector?(".get-started-intro", text: "This is the introduction to carrots")

            assert_has_button_as_link("Eat Carrots Now",
                                      href: "http://carrots.example.com",
                                      start: true,
                                      rel: "external")

            assert page.has_content?("Carrotworld")
          end
        end
      end

      within(".help-notice") do
        assert page.has_content?("CarrotServe will be offline next week.")
      end
    end

    should "present the FAQ schema correctly" do
      register_to_vote = @payload.merge(base_path: "/register-to-vote")
      content_store_has_item("/register-to-vote", register_to_vote)

      visit "/register-to-vote"

      assert_equal 200, page.status_code

      schema_sections = page.find_all("script[type='application/ld+json']", visible: false)
      schemas = schema_sections.map { |section| JSON.parse(section.text(:all)) }

      faq_schema = schemas.detect { |schema| schema["@type"] == "FAQPage" }

      expected_faq = {
        "@context" => "http://schema.org",
        "@type" => "FAQPage",
        "headline" => "Register to vote",
        "description" => "<p>Register to vote to get on the electoral register, or to change your details. It usually takes about 5 minutes.</p> <p>You need to be on the electoral register to vote in general elections or referendums.</p>\n",
        "publisher" => {
          "@type" => "Organization",
          "name" => "GOV.UK",
          "url" => "https://www.gov.uk",
          "logo" => {
            "@type" => "ImageObject",
            "url" => "/frontend/govuk_publishing_components/govuk-logo-e5962881254c9adb48f94d2f627d3bb67f258a6cbccc969e80abb7bbe4622976.png",
          },
        },
        "mainEntity" => [
          {
            "@type" => "Question",
            "name" => "Deadline for registering to vote in the General Election",
            "acceptedAnswer" => {
              "@type" => "Answer",
              "text" => "<p>Register by 11:59pm on 26 November to vote in the General Election on 12 December.</p> <p>If you want to apply to <a href=\"/voting-in-the-uk?src=schema#postal-voting\">vote by post</a> in England, Scotland or Wales, register before 5pm on 26 November.</p> <p>If you’re going to be abroad on election day, you can apply to <a href=\"/voting-in-the-uk?src=schema#voting-by-proxy\">vote by proxy</a> after you’ve registered. It takes time to vote by post from overseas.</p> <p>It is too late to apply to vote by post or proxy if you live in Northern Ireland.</p>\n",
            },
          },
          {
            "@type" => "Question",
            "name" => "Who can register",
            "acceptedAnswer" => {
              "@type" => "Answer",
              "text" => "<p>You can register if you’re both:</p> <ul>\n <li>aged 16 or over (or 14 or over in Scotland)</li>\n <li>a UK citizen (or an Irish, EU or Commonwealth citizen with a permanent UK address)</li>\n</ul> <p>You will not be able to vote until you’re 18. If you live in Scotland, you can vote in Scottish Parliament and local elections when you’re 16.</p>\n",
            },
          },
          {
            "@type" => "Question",
            "name" => "Registering online",
            "acceptedAnswer" => {
              "@type" => "Answer",
              "text" => "<p>Use this service to get on the electoral register. You need to be on the electoral register to vote in elections and referendums.</p> <p>You only need to register once - not for every election.</p> <p><a rel=\"external\" href=\"https://www.registertovote.service.gov.uk/register-to-vote/start?src=schema\">Start now</a></p> <h2>What you need to know</h2> <p>You’ll be asked for your National Insurance number (but you can still register if you do not have one).</p>\n",
            },
          },
          {
            "@type" => "Question",
            "name" => "How to check if you’re already registered",
            "acceptedAnswer" => {
              "@type" => "Answer",
              "text" => "<p>Contact your local Electoral Registration Office to <a href=\"/get-on-electoral-register?src=schema\">find out if you’re already registered to vote</a>.</p>\n",
            },
          },
          {
            "@type" => "Question",
            "name" => "Updating your registration",
            "acceptedAnswer" => {
              "@type" => "Answer",
              "text" => "<p>You can also use the <a rel=\"external\" href=\"https://www.registertovote.service.gov.uk/register-to-vote/start?src=schema\">‘Register to vote’ service</a> to:</p> <ul>\n <li>change your name, address or nationality</li>\n <li>get on or off the <a href=\"/electoral-register?src=schema\">open register</a>\n</li> </ul> <p>To do this, you need to register again with your new details (even if you’re already registered to vote).</p>\n",
            },
          },
          {
            "@type" => "Question",
            "name" => "Registering with a paper form",
            "acceptedAnswer" => {
              "@type" => "Answer",
              "text" => "<p>You can:</p> <ul>\n <li><a href=\"/government/publications/register-to-vote-if-youre-living-in-the-uk?src=schema\">register using a paper form in England, Wales and Scotland</a></li>\n <li><a rel=\"external\" href=\"http://www.eoni.org.uk/Register-To-Vote/Register-to-vote-change-address-change-name?src=schema\">register using a paper form in Northern Ireland</a></li>\n</ul>\n",
            },
          },
          {
            "@type" => "Question",
            "name" => "If you live abroad",
            "acceptedAnswer" => {
              "@type" => "Answer",
              "text" => "<p>You can use this service to <a rel=\"external\" href=\"https://www.registertovote.service.gov.uk/register-to-vote/start?src=schema\">apply to register to vote</a> (or to renew or update your registration) if you:</p> <ul>\n <li>are a British citizen</li>\n <li>left the UK within the last 15 years</li>\n <li>were previously registered at an address in England, Scotland or Wales (or, in some cases, you left the UK before your 18th birthday)</li>\n</ul> <p>You’ll need your passport details if you’re a British citizen living abroad, and want to vote in England, Scotland or Wales.</p> <p>If you previously lived in Northern Ireland and want to vote there, use the <a rel=\"external\" href=\"http://www.eoni.org.uk/Register-To-Vote/Special-Category-Registration?src=schema\">Northern Ireland overseas elector registration form</a>.</p>\n",
            },
          },
          {
            "@type" => "Question",
            "name" => "If you’re a public servant posted overseas",
            "acceptedAnswer" => {
              "@type" => "Answer",
              "text" => "<p>There’s a different service for public servants (and their spouses and civil partners) who are posted overseas as:</p> <ul>\n <li><a href=\"/register-to-vote-crown-servants-british-council-employees?src=schema\">Crown servants or British council employees</a></li>\n <li>members of the <a href=\"/register-to-vote-armed-forces?src=schema\">armed forces</a>\n</li> </ul>\n",
            },
          },
          {
            "@type" => "Question",
            "name" => "Get help registering",
            "acceptedAnswer" => {
              "@type" => "Answer",
              "text" => "<p>You can get help registering from your local <a href=\"/get-on-electoral-register?src=schema\">Electoral Registration Office</a>.</p> <p>There’s an <a href=\"/government/publications/registering-to-vote-easy-read-guide?src=schema\">easy read guide about registering to vote</a> for people with a learning disability.</p>\n",
            },
          },
        ],
      }

      assert_equal expected_faq, faq_schema
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
      content_store_has_item("/carrots", carrot_service_with_org)

      visit "/carrots"

      schema_sections = page.find_all("script[type='application/ld+json']", visible: false)
      schemas = schema_sections.map { |section| JSON.parse(section.text(:all)) }

      service_schema = schemas.detect { |schema| schema["@type"] == "GovernmentService" }

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
      assert_has_button_as_link("Start now",
                                href: "https://jobsearch.direct.gov.uk/JobSearch/PowerSearch.aspx")
    end
  end

  context "start page which should have cross domain analytics" do
    should "include cross domain analytics javascript" do
      content_store_has_example_item("/foo", schema: "transaction", example: "transaction")
      visit "/foo"

      assert_equal 200, page.status_code
      assert_has_button_as_link("Start now",
                                rel: "external",
                                href: "http://cti.voa.gov.uk/cti/inits.asp",
                                start: true,
                                data_attributes: {
                                  "module" => "cross-domain-tracking",
                                  "tracking-code" => "UA-12345-6",
                                  "tracking-name" => "transactionTracker",
                                })
    end
  end

  context "start page format which shouldn't have cross domain analytics" do
    should "not include cross domain analytics javascript" do
      content_store_has_example_item("/foo", schema: "transaction", example: "jobsearch")
      visit "/foo"

      assert_equal 200, page.status_code
      assert_has_button_as_link("Start now",
                                rel: "external",
                                start: true,
                                href: "https://jobsearch.direct.gov.uk/JobSearch/PowerSearch.aspx")
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
      content_store_has_item("/cymraeg", @payload)
    end

    should "render start button text 'Dechrau nawr'" do
      visit "/cymraeg"

      within ".article-container" do
        within "section.intro" do
          assert_has_button_as_link("Dechrau nawr",
                                    rel: "external",
                                    start: true,
                                    href: "http://cymraeg.example.com")
        end
      end
    end
  end

  context "a transaction has variants" do
    should "render correct content including robots meta tag" do
      content_store_has_example_item("/council-tax-bands-2", schema: "transaction", example: "transaction-with-variants")
      visit "/council-tax-bands-2/council-tax-bands-2-staging"

      assert_equal 200, page.status_code
      assert_has_button_as_link("Start now",
                                href: "http://cti-staging.voa.gov.uk/cti/inits.asp")

      within "#content/header" do
        assert_has_component_title "Check your Council Tax band (staging)"
      end

      within "head", visible: :all do
        assert page.has_selector?("meta[name='robots'][content='noindex, nofollow']", visible: false)
      end
    end
  end
end
