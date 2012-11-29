require_relative '../integration_test_helper'

class PageRenderingTest < ActionDispatch::IntegrationTest

  test "returns 503 if backend times out" do
    stub_request(:get, "http://contentapi.test.gov.uk/my-item.json").to_timeout
    visit "/my-item"
    assert_equal 503, page.status_code
  end

  test "returns 503 if backend unavailable" do
    stub_request(:get, "http://contentapi.test.gov.uk/my-item.json").to_return(:status => 500)
    visit "/my-item"
    assert_equal 503, page.status_code
  end

  test "quick_answer request" do
    setup_api_responses('vat-rates')
    visit "/vat-rates"
    assert_equal 200, page.status_code
    assert page.has_selector?("#wrapper #content .article-container #test-report_a_problem")
  end

  test "programme request" do
    setup_api_responses('reduced-earnings-allowance')
    visit "/reduced-earnings-allowance"
    assert_equal 200, page.status_code
    assert page.has_selector?("#wrapper #content .article-container #test-report_a_problem")
  end

  test "completed transaction request" do
    artefact = artefact_for_slug "done/completed-transaction-test"
    artefact = artefact.merge({
      format: "completed_transaction"
    })
    content_api_has_an_artefact('done/completed-transaction-test', artefact)
    visit "/done/completed-transaction-test"
    assert_equal 200, page.status_code
  end

  test "business support request" do
    artefact = artefact_for_slug "business-support-example"
    artefact = artefact.merge({
      format: "business_support",
      business_support_id: "123"
    })
    content_api_has_an_artefact('business-support-example', artefact)
    visit "business-support-example"
    assert_equal 200, page.status_code
  end

  test "viewing a licence page" do
    setup_api_responses('licence-generic')
    visit "/licence-generic"
    assert_equal 200, page.status_code
    assert page.has_content?("Licence overview copy"), %(expected there to be content Licence overview copy in #{page.text.inspect})
    assert page.has_selector?("#wrapper #content .article-container #test-report_a_problem")
  end

  test "viewing a business support page" do
    artefact = artefact_for_slug "business-support-example"
    artefact = artefact.merge({"format" => "business_support"})
    artefact = artefact.merge(content_api_response("business-support-example"))
    content_api_has_an_artefact('business-support-example', artefact)
    visit "/business-support-example"
    assert_equal 200, page.status_code
    assert page.has_content? "Business support example"
    assert page.has_content? "Provides UK businesses with free, quick and easy access to a directory of approved finance suppliers"
    assert page.has_content? "How much you can get"
    assert_match /1 -.*?20000000/, page.text
    assert page.has_content? "Eligibility"
    assert page.has_content? "Will depend on the individual provider."
    assert page.has_link? "Find out more", href: "http://www.businessfinanceforyou.co.uk/finance-finder"
    assert page.has_content? "What you need to know"
    assert page.has_content? "Additional information"
    assert page.has_selector?("#wrapper #content .article-container #test-report_a_problem")
  end

  test "looking for last updated at" do
    content_api_has_an_artefact("example-answer", {
      "format" => "answer",
      "title" => "Is it me you're looking for?",
      "web_url" => "https://www.gov.uk/example-answer",
      "details" => {
        "body" => "No."
      },
      "updated_at" => "2012-10-09T09:59:15+00:00",
      "tags" => [],
      "related" => []
    })

    visit '/example-answer'
    assert page.has_content? "Last updated: 09 October 2012"
  end

  # Crude way of handling the situation described at
  # http://stackoverflow.com/a/3443678
  test "requests for gifs 404" do
    visit "/crisis-loans/refresh.gif"
    assert_equal 404, page.status_code

    visit "/refresh.gif"
    assert_equal 404, page.status_code

    visit "/pagerror.gif"
    assert_equal 404, page.status_code
  end

  test "rendering a print view of a programme" do
    setup_api_responses("child-tax-credit")

    visit "/child-tax-credit/print"
    assert page.has_content?("Get Child Tax Credit")
  end

  test "rendering a print view of a guide" do
    setup_api_responses("ride-a-motorcycle-or-moped")

    visit "/ride-a-motorcycle-or-moped/print"
    assert page.has_content?("Ride a motorcycle or moped")
  end

  test "rendering a help page" do
    visit "/help/accessibility"
    assert_equal 200, page.status_code
  end

  test "rendering a programme edition's 'further information' page should keep the query string intact" do
    Capybara.current_driver = Capybara.javascript_driver

    artefact = artefact_for_slug("married-couples-allowance").merge(
      "format" => "programme",
      "details" => {
        "parts" => [
          {
             "body" => "Married Couple's Allowance could reduce your tax bill by \u00a3280 to \u00a3729.50 a year.\r\n\r\nYou must be married or in a civil partnership to claim and one of you must have been **born before 6 April 1935**.\r\n\r\nFor marriages before 5 December 2005 the husband's income is used to work out Married Couple's Allowance. For marriage and civil partnerships after this date, it's the income of the highest earner.",
             "slug" => "overview",
             "title" => "Overview"
          },
          {
             "body" => "##Transfer your MCA after the end of the tax year\r\nIf your spouse or civil partner pays tax, you can transfer any unused allowance to them if:\r\n\r\n- you don\u2019t pay tax\r\n- your tax bill isn't high enough\r\n\r\nUse the form below or contact [HM Revenue & Customs (HMRC)](/married-couples-allowance#how-to-claim \"Contact HM Revenue & Customs\") who can post you a copy. \r\n\r\n$D\r\n[Download form 575 'Notice of transfer of surplus Income Tax allowances' - (PDF, 64KB)](http://www.hmrc.gov.uk/forms/575-t-man.pdf \"Form 575 - Notice of transfer of surplus Income Tax allowances\"){:rel=\"external\"} \r\n$D\r\n\r\n##Share or transfer your MCA before the start of the tax year\r\nYou and your spouse (or civil partner) can also:\r\n\r\n- share the minimum MCA\r\n- transfer the whole of the minimum MCA from one to the other\r\n\r\nComplete the form below before the start of the tax year - you can also contact [HMRC](/married-couples-allowance#how-to-claim \"Contact HM Revenue & Customs\") to get a copy in the post.\r\n\r\n$D\r\n[Download form 18 'Transferring the Married Couple\u2019s Allowance' - (PDF, 88KB)](http://www.hmrc.gov.uk/forms/18.pdf \"form 18 - Transferring the Married Couple\u2019s Allowance\"){:rel=\"external\"}\r\n$D\r\n\r\n##Tax allowances and giving to charity\r\n\r\nIf you pay tax and give money to a UK charity using Gift Aid, let [HMRC](/married-couples-allowance#how-to-claim \"HM Revenue & Customs\") know. It reduces your income when they calculate your age-related allowances.\r\n\r\n\r\n\r\n*[MCA]: Married Couple's Allowance\r\n*[HMRC]: HM Revenue & Customs\r\n\r\n",
             "slug" => "further-information",
             "title" => "Further information"
          }
        ]
      }
    )
    content_api_has_unpublished_artefact("married-couples-allowance", 5, artefact)

    visit "/married-couples-allowance/further-information?edition=5"

    assert page.has_content? "Overview"

    within ".page-navigation" do
      click_link "Overview"
    end

    assert_equal 200, page.status_code
    assert_equal "/married-couples-allowance/overview?edition=5", current_url[/\/(?!.*\.).*/]
  end

  test "viewing a video answer page" do
    setup_api_responses('test-video')
    visit "/test-video"
    assert_equal 200, page.status_code
    within '#content' do
      assert page.has_content?("This is the video summary")
      assert page.has_selector?("figure#video a[href='https://www.youtube.com/watch?v=fLreo24WYeQ']")
      assert page.has_content?("Video description")
    end
    assert page.has_selector?("#wrapper #content .article-container #test-report_a_problem")
  end
end
