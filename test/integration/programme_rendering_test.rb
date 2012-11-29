# encoding: utf-8
require_relative '../integration_test_helper'

class ProgrammeRenderingTest < ActionDispatch::IntegrationTest

  should "render a programme correctly" do
    setup_api_responses('reduced-earnings-allowance')
    visit "/reduced-earnings-allowance"

    assert_equal 200, page.status_code

    within 'head' do
      assert page.has_selector?("title", :text => "Reduced Earnings Allowance - GOV.UK")
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/reduced-earnings-allowance.json']")
    end

    within '#content' do
      within 'header' do
        assert page.has_content?("Reduced Earnings Allowance")
        assert page.has_content?("Benefits & credits")
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
            assert page.has_selector?("li.next a[rel=next][href='/reduced-earnings-allowance/what-youll-get']",
                                      :text => "Part 2 What you'll get",
                                      :title => "Navigate to next part")
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
          assert page.has_selector?("li.previous a[rel=prev][href='/reduced-earnings-allowance/what-youll-get']",
                                    :text => "Part 2 What you'll get",
                                    :title => "Navigate to previous part")
          assert page.has_selector?("li.next a[rel=next][href='/reduced-earnings-allowance/how-to-claim']",
                                    :text => "Part 4 How to claim",
                                    :title => "Navigate to next part")
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
          assert page.has_selector?("li.previous a[rel=prev][href='/reduced-earnings-allowance/how-to-claim']",
                                    :text => "Part 4 How to claim",
                                    :title => "Navigate to previous part")
          assert page.has_selector?("li.last", :text => "You have reached the end of this guide")
        end
      end
    end
  end

  should "render the print view of a guide correctly" do
    setup_api_responses('reduced-earnings-allowance')
    visit "/reduced-earnings-allowance/print"

    within "section[role=main]" do
      within "header h1" do
        assert page.has_content?("Benefits & credits: Reduced Earnings Allowance")
      end

      within "article#overview" do
        assert page.has_selector?("header h1", :text => "Part 1: Overview")
        assert page.has_selector?("h2", :text => "Effect on other benefits")
      end

      within "article#what-youll-get" do
        assert page.has_selector?("header h1", :text => "Part 2: What you'll get")
        assert page.has_selector?("p", :text => "£63.24 per week is the maximum rate. ")
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
