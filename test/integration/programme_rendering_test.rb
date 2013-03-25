# encoding: utf-8
require_relative '../integration_test_helper'

class ProgrammeRenderingTest < ActionDispatch::IntegrationTest

  should "render a programme correctly" do
    setup_api_responses('reduced-earnings-allowance')
    visit "/reduced-earnings-allowance"

    assert_equal 200, page.status_code

    within 'head' do
      assert_equal "Reduced Earnings Allowance - GOV.UK", find("title").native.text
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/reduced-earnings-allowance.json']")
    end

    within '#content' do
      within first('header') do
        assert page.has_content?("Reduced Earnings Allowance")
        assert page.has_content?("Benefits & credits")
        assert page.has_link?("Not what you're looking for? ↓", :href => "#related")
      end

      within '.article-container' do
        within 'aside nav' do
          part_titles = page.all('li').map(&:text).map(&:strip)
          assert_equal ['Part 1: Overview', "Part 2: What you'll get", 'Part 3: Eligibility', 'Part 4: How to claim', 'Part 5: Further information'], part_titles

          assert page.has_link?("Part 2: What you'll get", :href => "/reduced-earnings-allowance/what-youll-get")
          assert page.has_link?("Part 5: Further information", :href => "/reduced-earnings-allowance/further-information")
        end

        within 'article' do
          within('header') { assert page.has_content?("Part 1: Overview") }

          assert page.has_selector?("h2", :text => "Effect on other benefits")

          within 'footer nav.pagination' do
            assert page.has_selector?("li.first", :text => "You are at the beginning of this guide")
            assert page.has_selector?("li.next a[rel=next][href='/reduced-earnings-allowance/what-youll-get'][title='Navigate to next part']",
                                      :text => "Part 2 What you'll get")
          end
        end

        assert page.has_selector?(".modified-date", :text => "Last updated: 12 November 2012")
        assert page.has_selector?(".print-link a[rel=nofollow][href='/reduced-earnings-allowance/print']", :text => "Printer friendly page")

        assert page.has_selector?("#test-report_a_problem")
      end
    end # within #content

    assert page.has_selector?("#test-related")

    within('#content aside nav') { click_on "Eligibility" }

    assert_current_url "/reduced-earnings-allowance/eligibility"
    
    within '#content .article-container' do
      within 'aside nav' do
        part_titles = page.all('li').map(&:text).map(&:strip)
        assert_equal ['Part 1: Overview', "Part 2: What you'll get", 'Part 3: Eligibility', 'Part 4: How to claim', 'Part 5: Further information'], part_titles

        assert page.has_link?("Part 1: Overview", :href => "/reduced-earnings-allowance/overview")
        assert page.has_link?("Part 4: How to claim", :href => "/reduced-earnings-allowance/how-to-claim")
      end

      within 'article' do
        within('header') { assert page.has_content?("Part 3: Eligibility") }

        assert page.has_selector?("h2", :text => "Going abroad")

        within 'footer nav.pagination' do
          assert page.has_selector?("li.previous a[rel=prev][href='/reduced-earnings-allowance/what-youll-get'][title='Navigate to previous part']",
                                    :text => "Part 2 What you'll get")
          assert page.has_selector?("li.next a[rel=next][href='/reduced-earnings-allowance/how-to-claim'][title='Navigate to next part']",
                                    :text => "Part 4 How to claim")
        end
      end
    end

    within('#content aside nav') { click_on "Further information" }

    assert_current_url "/reduced-earnings-allowance/further-information"

    within '#content .article-container' do
      within 'aside nav' do
        part_titles = page.all('li').map(&:text).map(&:strip)
        assert_equal ['Part 1: Overview', "Part 2: What you'll get", 'Part 3: Eligibility', 'Part 4: How to claim', 'Part 5: Further information'], part_titles

        assert page.has_link?("Part 1: Overview", :href => "/reduced-earnings-allowance/overview")
        assert page.has_link?("Part 3: Eligibility", :href => "/reduced-earnings-allowance/eligibility")
      end

      within 'article' do
        within('header') { assert page.has_content?("Part 5: Further information") }

        assert page.has_selector?("h3", :text => "Scotland, North West England, East of England, South East England and London")

        within 'footer nav.pagination' do
          assert page.has_selector?("li.previous a[rel=prev][href='/reduced-earnings-allowance/how-to-claim'][title='Navigate to previous part']",
                                    :text => "Part 4 How to claim")
          assert page.has_selector?("li.last", :text => "You have reached the end of this guide")
        end
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
      within first('header') do
        assert page.has_content?("Budd-daliadau a chredydau")
        assert page.has_content?("Reduced Earnings Allowance")
        assert page.has_link?("Ddim beth rydych chi’n chwilio amdano? ↓", :href => "#related")
      end

      within '.article-container' do
        within 'aside nav' do
          part_titles = page.all('li').map(&:text).map(&:strip)
          assert_equal ['Rhan 1: Overview', "Rhan 2: What you'll get", 'Rhan 3: Eligibility', 'Rhan 4: How to claim', 'Rhan 5: Further information'], part_titles

          assert page.has_link?("Rhan 2: What you'll get", :href => "/reduced-earnings-allowance/what-youll-get")
          assert page.has_link?("Rhan 5: Further information", :href => "/reduced-earnings-allowance/further-information")
        end

        within 'article' do
          within('header') { assert page.has_content?("Rhan 1: Overview") }

          within 'footer nav.pagination' do
            assert page.has_selector?("li.first", :text => "Rydych chi ar ddechrau’r canllaw hwn")
            assert page.has_selector?("li.next a[rel=next][href='/reduced-earnings-allowance/what-youll-get'][title='Llywio i’r rhan nesaf']",
                                      :text => "Rhan 2 What you'll get")
          end
        end

        assert page.has_selector?(".modified-date", :text => "Diweddarwyd diwethaf: 12 Tachwedd 2012")
        assert page.has_selector?(".print-link a[rel=nofollow][href='/reduced-earnings-allowance/print']", :text => "Tudalen hawdd ei hargraffu")
      end
    end # within #content

    within('#content aside nav') { click_on "Further information" }

    assert_current_url "/reduced-earnings-allowance/further-information"

    within '#content .article-container' do

      within 'article' do
        within('header') { assert page.has_content?("Rhan 5: Further information") }

        within 'footer nav.pagination' do
          assert page.has_selector?("li.previous a[rel=prev][href='/reduced-earnings-allowance/how-to-claim'][title='Llywio i’r rhan flaenorol']",
                                    :text => "Rhan 4 How to claim")
          assert page.has_selector?("li.last", :text => "Rydych wedi cyrraedd diwedd y canllaw hwn")
        end
      end
    end
  end

  should "render the print view of a programme correctly" do
    setup_api_responses('reduced-earnings-allowance')
    visit "/reduced-earnings-allowance/print"

    within "section[role=main]" do
      within first("header") do
        assert_equal "Benefits & credits: Reduced Earnings Allowance", find("h1").text
      end

      within "article#overview" do
        assert page.has_selector?("header h1", :text => "Part 1: Overview")
        assert page.has_selector?("h2", :text => "Effect on other benefits")
      end

      within "article#what-youll-get" do
        assert page.has_selector?("header h1", :text => "Part 2: What you'll get")
        assert_equal "£63.24 per week is the maximum rate.", first("p").text
      end

      within "article#eligibility" do
        assert page.has_selector?("header h1", :text => "Part 3: Eligibility")
        assert page.has_selector?("h2", :text => "Going abroad")
      end

      within "article#how-to-claim" do
        assert page.has_selector?("header h1", :text => "Part 4: How to claim")
        assert page.has_selector?("p", :text => "Claim straight away or you might lose benefit.")
      end

      within "article#further-information" do
        assert page.has_selector?("header h1", :text => "Part 5: Further information")
        assert page.has_selector?("h3", :text => "Scotland, North West England, East of England, South East England and London")
      end

      assert page.has_selector?(".modified-date", :text => "Last updated: 12 November 2012")
    end
  end

  should "render the print view of a welsh programme correctly" do
    # Note, this is using an english piece of content set to Welsh
    # This is fine because we're testing the page furniture, not the rendering of the content.
    artefact = content_api_response('reduced-earnings-allowance')
    artefact["details"]["language"] = "cy"
    content_api_has_an_artefact('reduced-earnings-allowance', artefact)

    visit "/reduced-earnings-allowance/print"

    within "section[role=main]" do
      within first("header") do
        assert_equal "Budd-daliadau a chredydau: Reduced Earnings Allowance", find("h1").text
      end

      within "article#overview" do
        assert page.has_selector?("header h1", :text => "Rhan 1: Overview")
      end

      within "article#what-youll-get" do
        assert page.has_selector?("header h1", :text => "Rhan 2: What you'll get")
      end

      within "article#eligibility" do
        assert page.has_selector?("header h1", :text => "Rhan 3: Eligibility")
      end

      within "article#how-to-claim" do
        assert page.has_selector?("header h1", :text => "Rhan 4: How to claim")
      end

      within "article#further-information" do
        assert page.has_selector?("header h1", :text => "Rhan 5: Further information")
      end

      assert page.has_selector?(".modified-date", :text => "Diweddarwyd diwethaf: 12 Tachwedd 2012")
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
