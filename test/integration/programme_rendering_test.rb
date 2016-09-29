# encoding: utf-8
require 'integration_test_helper'

class ProgrammeRenderingTest < ActionDispatch::IntegrationTest
  should "render a programme correctly" do
    setup_api_responses('reduced-earnings-allowance')
    visit "/reduced-earnings-allowance"

    assert_equal 200, page.status_code

    within 'head', visible: :all do
      assert page.has_selector?("title", text: "Reduced Earnings Allowance - GOV.UK", visible: :all)
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/reduced-earnings-allowance.json']", visible: :all)
    end

    within '#content' do
      within 'header.page-header' do
        assert page.has_content?("Reduced Earnings Allowance")
      end

      within '.article-container' do
        assert page.has_selector?(shared_component_selector('beta_label'))

        within 'aside nav' do
          part_titles = page.all('li').map(&:text).map(&:strip)
          assert_equal ['1. Overview', "2. What you'll get", '3. Eligibility', '4. How to claim', '5. Further information'], part_titles

          assert page.has_link?("What you'll get", href: "/reduced-earnings-allowance/what-youll-get")
          assert page.has_link?("Further information", href: "/reduced-earnings-allowance/further-information")
        end

        within('header') { assert page.has_content?("1. Overview") }

        assert page.has_selector?("h2", text: "Effect on other benefits")

        within 'footer nav.pagination' do
          assert page.has_selector?("li.next a[rel=next][href='/reduced-earnings-allowance/what-youll-get'][title='Navigate to next part']",
                                    text: "What you'll get")
          assert_equal 1, page.all('li').count
        end

        assert page.has_selector?(".modified-date", text: "Last updated: 12 November 2012")
        assert page.has_selector?(".print-link a[rel=nofollow][href='/reduced-earnings-allowance/print']", text: "Print entire guide")
      end
    end # within #content

    assert page.has_selector?("#test-related")

    within('#content aside nav') { click_on "Eligibility" }

    assert_current_url "/reduced-earnings-allowance/eligibility"

    within '#content .article-container' do
      within 'aside nav' do
        part_titles = page.all('li').map(&:text).map(&:strip)
        assert_equal ['1. Overview', "2. What you'll get", '3. Eligibility', '4. How to claim', '5. Further information'], part_titles

        assert page.has_link?("Overview", href: "/reduced-earnings-allowance/overview")
        assert page.has_link?("How to claim", href: "/reduced-earnings-allowance/how-to-claim")
      end

      within('header') { assert page.has_content?("3. Eligibility") }

      assert page.has_selector?("h2", text: "Going abroad")

      within 'footer nav.pagination' do
        assert page.has_selector?("li.previous a[rel=prev][href='/reduced-earnings-allowance/what-youll-get'][title='Navigate to previous part']",
                                  text: "What you'll get")
        assert page.has_selector?("li.next a[rel=next][href='/reduced-earnings-allowance/how-to-claim'][title='Navigate to next part']",
                                  text: "How to claim")
      end
    end

    within('#content aside nav') { click_on "Further information" }

    assert_current_url "/reduced-earnings-allowance/further-information"

    within '#content .article-container' do
      within 'aside nav' do
        part_titles = page.all('li').map(&:text).map(&:strip)
        assert_equal ['1. Overview', "2. What you'll get", '3. Eligibility', '4. How to claim', '5. Further information'], part_titles

        assert page.has_link?("Overview", href: "/reduced-earnings-allowance/overview")
        assert page.has_link?("Eligibility", href: "/reduced-earnings-allowance/eligibility")
      end

      within('header') { assert page.has_content?("5. Further information") }

      assert page.has_selector?("h3", text: "Scotland, North West England, East of England, South East England and London")

      within 'footer nav.pagination' do
        assert page.has_selector?("li.previous a[rel=prev][href='/reduced-earnings-allowance/how-to-claim'][title='Navigate to previous part']",
                                  text: "How to claim")
        assert_equal 1, page.all('li').count
      end
    end
  end

  should "render a programme with a single part correctly" do
    setup_api_responses('warm-front-scheme')
    visit "/warm-front-scheme"

    assert_equal 200, page.status_code

    within '#wrapper' do
      assert page.has_selector?("#content.single-page")
      within '#content .article-container' do
        assert page.has_no_xpath?("./aside")
        assert page.has_no_xpath?("./header")
        assert page.has_no_xpath?("./footer")
      end
    end
  end

  should "render a Welsh programme correctly" do
    # Note, this is using an english piece of content set to Welsh
    # This is fine because we're testing the page furniture, not the rendering of the content.
    artefact = content_api_response('reduced-earnings-allowance')
    artefact["details"]["language"] = "cy"
    content_api_has_an_artefact('reduced-earnings-allowance', artefact)

    visit "/reduced-earnings-allowance"

    assert_equal 200, page.status_code

    within '#content' do
      within 'header.page-header' do
        assert page.has_content?("Reduced Earnings Allowance")
      end

      within '.article-container' do
        within 'aside nav' do
          part_titles = page.all('li').map(&:text).map(&:strip)
          assert_equal ['1. Overview', "2. What you'll get", '3. Eligibility', '4. How to claim', '5. Further information'], part_titles

          assert page.has_link?("What you'll get", href: "/reduced-earnings-allowance/what-youll-get")
          assert page.has_link?("Further information", href: "/reduced-earnings-allowance/further-information")
        end

        within('header') { assert page.has_content?("1. Overview") }

        within 'footer nav.pagination' do
          assert page.has_selector?("li.next a[rel=next][href='/reduced-earnings-allowance/what-youll-get'][title='Llywio i’r rhan nesaf']",
                                    text: "What you'll get")
          assert_equal 1, page.all('li').count
        end

        assert page.has_selector?(".modified-date", text: "Diweddarwyd diwethaf: 12 Tachwedd 2012")
        assert page.has_selector?(".print-link a[rel=nofollow][href='/reduced-earnings-allowance/print']", text: "Tudalen hawdd ei hargraffu")
      end
    end # within #content

    within('#content aside nav') { click_on "Further information" }

    assert_current_url "/reduced-earnings-allowance/further-information"

    within '#content .article-container' do
      within('header') { assert page.has_content?("5. Further information") }

      within 'footer nav.pagination' do
        assert page.has_selector?("li.previous a[rel=prev][href='/reduced-earnings-allowance/how-to-claim'][title='Llywio i’r rhan flaenorol']",
                                  text: "How to claim")
        assert_equal 1, page.all('li').count
      end
    end
  end

  should "render the print view of a programme correctly" do
    setup_api_responses('reduced-earnings-allowance')
    visit "/reduced-earnings-allowance/print"

    within "main[role=main]" do
      within first("header h1") do
        assert page.has_content?("Benefits & credits: Reduced Earnings Allowance")
      end

      within "#overview" do
        assert page.has_selector?("header h1", text: "1. Overview")
        assert page.has_selector?("h2", text: "Effect on other benefits")
      end

      within "#what-youll-get" do
        assert page.has_selector?("header h1", text: "2. What you'll get")
        assert page.has_selector?("p", text: "£63.24 per week is the maximum rate.")
      end

      within "#eligibility" do
        assert page.has_selector?("header h1", text: "3. Eligibility")
        assert page.has_selector?("h2", text: "Going abroad")
      end

      within "#how-to-claim" do
        assert page.has_selector?("header h1", text: "4. How to claim")
        assert page.has_selector?("p", text: "Claim straight away or you might lose benefit.")
      end

      within "#further-information" do
        assert page.has_selector?("header h1", text: "5. Further information")
        assert page.has_selector?("h3", text: "Scotland, North West England, East of England, South East England and London")
      end

      assert page.has_selector?(".modified-date", text: "Last updated: 12 November 2012")
    end
  end

  should "render the print view of a welsh programme correctly" do
    # Note, this is using an english piece of content set to Welsh
    # This is fine because we're testing the page furniture, not the rendering of the content.
    artefact = content_api_response('reduced-earnings-allowance')
    artefact["details"]["language"] = "cy"
    content_api_has_an_artefact('reduced-earnings-allowance', artefact)

    visit "/reduced-earnings-allowance/print"

    within "main[role=main]" do
      within first("header h1") do
        assert page.has_content?("Budd-daliadau a chredydau: Reduced Earnings Allowance")
      end

      within "#overview" do
        assert page.has_selector?("header h1", text: "1. Overview")
      end

      within "#what-youll-get" do
        assert page.has_selector?("header h1", text: "2. What you'll get")
      end

      within "#eligibility" do
        assert page.has_selector?("header h1", text: "3. Eligibility")
      end

      within "#how-to-claim" do
        assert page.has_selector?("header h1", text: "4. How to claim")
      end

      within "#further-information" do
        assert page.has_selector?("header h1", text: "5. Further information")
      end

      assert page.has_selector?(".modified-date", text: "Diweddarwyd diwethaf: 12 Tachwedd 2012")
    end
  end

  should "preserve the query string when navigating around a preview of a programme" do
    artefact = content_api_response('reduced-earnings-allowance')
    content_api_has_unpublished_artefact('reduced-earnings-allowance', 5, artefact)

    visit "/reduced-earnings-allowance/further-information?edition=5"

    assert page.has_content? "Overview"

    within ".page-navigation" do
      click_link "Overview"
    end

    assert_equal 200, page.status_code
    assert_current_url "/reduced-earnings-allowance/overview?edition=5"
  end
end
