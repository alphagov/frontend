require_relative '../integration_test_helper'

class GuideRenderingTest < ActionDispatch::IntegrationTest

  should "render a guide correctly" do
    setup_api_responses('data-protection')
    visit "/data-protection"

    assert_equal 200, page.status_code

    within 'head' do
      assert page.has_selector?("title", :text => "Data protection - GOV.UK")
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/data-protection.json']")
    end

    within '#content' do
      within 'header' do
        assert page.has_content?("Data protection")
        assert page.has_content?("Guide")
      end

      within '.article-container' do
        within 'aside nav' do
          part_titles = page.all('li').map(&:text).map(&:strip)
          assert_equal ['Part 1: The Data Protection Act', 'Part 2: Find out what data an organisation has about you', 'Part 3: Make a complaint'], part_titles

          assert page.has_link?("Part 2: Find out what data an organisation has about you", :href => "/data-protection/find-out-what-data-an-organisation-has-about-you")
          assert page.has_link?("Part 3: Make a complaint", :href => "/data-protection/make-a-complaint")
        end

        within 'article' do
          within('header') { assert page.has_content?("Part 1: The Data Protection Act") }

          assert page.has_selector?("ul li", :text => "used fairly and lawfully")

          within 'footer nav.pagination' do
            assert page.has_selector?("li.first", :text => "You are at the beginning of this guide")
            assert page.has_selector?("li.next a[rel=next][href='/data-protection/find-out-what-data-an-organisation-has-about-you']",
                                      :text => "Part 2 Find out what data an organisation has about you",
                                      :title => "Navigate to next part")
          end
        end

        assert page.has_selector?(".modified-date", :text => "Last updated: 22 October 2012")
        assert page.has_selector?(".print-link a[rel=nofollow][href='/data-protection/print']", :text => "Printer friendly page")

        assert page.has_selector?("#test-report_a_problem")
      end
    end # within #content

    assert page.has_selector?("#test-related")

    within('#content aside nav') { click_on "Find out what data an organisation has about you" }

    assert_current_url "/data-protection/find-out-what-data-an-organisation-has-about-you"
    
    within '#content .article-container' do
      within 'aside nav' do
        part_titles = page.all('li').map(&:text).map(&:strip)
        assert_equal ['Part 1: The Data Protection Act', 'Part 2: Find out what data an organisation has about you', 'Part 3: Make a complaint'], part_titles

        assert page.has_link?("Part 1: The Data Protection Act", :href => "/data-protection/the-data-protection-act")
        assert page.has_link?("Part 3: Make a complaint", :href => "/data-protection/make-a-complaint")
      end

      within 'article' do
        within('header') { assert page.has_content?("Part 2: Find out what data an organisation has about you") }

        assert page.has_selector?("h2", :text => "When information can be withheld")

        within 'footer nav.pagination' do
          assert page.has_selector?("li.previous a[rel=prev][href='/data-protection/the-data-protection-act']",
                                    :text => "Part 1 The Data Protection Act",
                                    :title => "Navigate to previous part")
          assert page.has_selector?("li.next a[rel=next][href='/data-protection/make-a-complaint']",
                                    :text => "Part 3 Make a complaint",
                                    :title => "Navigate to next part")
        end
      end
    end

    within('#content article footer') { click_on "Make a complaint" }

    assert_current_url "/data-protection/make-a-complaint"

    within '#content .article-container' do
      within 'aside nav' do
        part_titles = page.all('li').map(&:text).map(&:strip)
        assert_equal ['Part 1: The Data Protection Act', 'Part 2: Find out what data an organisation has about you', 'Part 3: Make a complaint'], part_titles

        assert page.has_link?("Part 1: The Data Protection Act", :href => "/data-protection/the-data-protection-act")
        assert page.has_link?("Part 2: Find out what data an organisation has about you", :href => "/data-protection/find-out-what-data-an-organisation-has-about-you")
      end

      within 'article' do
        within('header') { assert page.has_content?("Part 3: Make a complaint") }

        assert page.has_selector?("p strong", :text => "ICO helpline")

        within 'footer nav.pagination' do
          assert page.has_selector?("li.previous a[rel=prev][href='/data-protection/find-out-what-data-an-organisation-has-about-you']",
                                    :text => "Part 2 Find out what data an organisation has about you",
                                    :title => "Navigate to previous part")
          assert page.has_selector?("li.last", :text => "You have reached the end of this guide")
        end
      end
    end
  end

  should "render the print view of a guide correctly" do
    setup_api_responses('data-protection')
    visit "/data-protection/print"

    within "section[role=main]" do
      within "header h1" do
        assert page.has_content?("Data protection, a guide from GOV.UK")
      end

      within "article#the-data-protection-act" do
        assert page.has_selector?("header h1", :text => "Part 1: The Data Protection Act")
        assert page.has_selector?("ul li", :text => "used fairly and lawfully")
      end

      within "article#find-out-what-data-an-organisation-has-about-you" do
        assert page.has_selector?("header h1", :text => "Part 2: Find out what data an organisation has about you")
        assert page.has_selector?("h2", :text => "When information can be withheld")
      end

      within "article#make-a-complaint" do
        assert page.has_selector?("header h1", :text => "Part 3: Make a complaint")
        assert page.has_selector?("p strong", :text => "ICO helpline")
      end

      assert page.has_selector?(".modified-date", :text => "Last updated: 22 October 2012")
    end
  end
end
