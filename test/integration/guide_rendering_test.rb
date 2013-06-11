# encoding: utf-8
require_relative '../integration_test_helper'

class GuideRenderingTest < ActionDispatch::IntegrationTest

  should "render a guide correctly" do
    setup_api_responses('data-protection')
    visit "/data-protection"

    assert_equal 200, page.status_code

    within 'head' do
      assert_equal "Data protection - GOV.UK", find("title").native.text
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/data-protection.json']")
    end

    within '#content' do
      within first('header') do
        assert page.has_content?("Data protection")
        assert page.has_content?("Guide")
        assert page.has_link?("Not what you're looking for? ↓", :href => "#related")
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
            assert page.has_selector?("li.next a[rel=next][href='/data-protection/find-out-what-data-an-organisation-has-about-you'][title='Navigate to next part']",
                                      :text => "Part 2 Find out what data an organisation has about you")
          end
        end

        assert page.has_selector?(".modified-date", :text => "Last updated: 22 October 2012")
        assert page.has_selector?(".print-link a[rel=nofollow][href='/data-protection/print']", :text => "Print entire guide")

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
          assert page.has_selector?("li.previous a[rel=prev][href='/data-protection/the-data-protection-act'][title='Navigate to previous part']",
                                    :text => "Part 1 The Data Protection Act")
          assert page.has_selector?("li.next a[rel=next][href='/data-protection/make-a-complaint'][title='Navigate to next part']",
                                    :text => "Part 3 Make a complaint")
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
          assert page.has_selector?("li.previous a[rel=prev][href='/data-protection/find-out-what-data-an-organisation-has-about-you'][title='Navigate to previous part']",
                                    :text => "Part 2 Find out what data an organisation has about you")
          assert page.has_selector?("li.last", :text => "You have reached the end of this guide")
        end
      end
    end
  end

  should "render a guide with a single part correctly" do
    setup_api_responses('building-regulations-competent-person-schemes')
    visit "/building-regulations-competent-person-schemes"

    assert_equal 200, page.status_code

    within '#wrapper' do
      assert page.has_selector?("#content.single-page")
      within '#content .article-container' do
        assert page.has_no_xpath?("./aside")
        assert page.has_no_xpath?("./article/div/header")
        assert page.has_no_xpath?("./article/div/footer")
      end
    end
  end

  should "render the Welsh version of a guide correctly" do
    # Note, this is using an english piece of content set to Welsh
    # This is fine because we're testing the page furniture, not the rendering of the content.
    artefact = content_api_response('data-protection')
    artefact["details"]["language"] = "cy"
    content_api_has_an_artefact('data-protection', artefact)

    visit "/data-protection"
    assert_equal 200, page.status_code

    within '#content' do
      within first('header') do
        assert page.has_content?("Canllaw")
        assert page.has_content?("Data protection")
        assert page.has_link?("Ddim beth rydych chi’n chwilio amdano? ↓", :href => "#related")
      end

      within '.article-container' do
        within 'aside nav' do
          part_titles = page.all('li').map(&:text).map(&:strip)
          assert_equal ['Rhan 1: The Data Protection Act', 'Rhan 2: Find out what data an organisation has about you', 'Rhan 3: Make a complaint'], part_titles

          assert page.has_link?("Rhan 2: Find out what data an organisation has about you", :href => "/data-protection/find-out-what-data-an-organisation-has-about-you")
          assert page.has_link?("Rhan 3: Make a complaint", :href => "/data-protection/make-a-complaint")
        end

        within 'article' do
          within('header') { assert page.has_content?("Rhan 1: The Data Protection Act") }

          within 'footer nav.pagination' do
            assert page.has_selector?("li.first", :text => "Rydych chi ar ddechrau’r canllaw hwn")
            assert page.has_selector?("li.next a[rel=next][href='/data-protection/find-out-what-data-an-organisation-has-about-you'][title='Llywio i’r rhan nesaf']",
                                      :text => "Rhan 2 Find out what data an organisation has about you")
          end
        end

        assert page.has_selector?(".modified-date", :text => "Diweddarwyd diwethaf: 22 Hydref 2012")
        assert page.has_selector?(".print-link a[rel=nofollow][href='/data-protection/print']", :text => "Tudalen hawdd ei hargraffu")
      end
    end # within #content

    within('#content aside nav') { click_on "Make a complaint" }

    assert_current_url "/data-protection/make-a-complaint"

    within '#content .article-container' do
      within 'article' do
        within('header') { assert page.has_content?("Rhan 3: Make a complaint") }

        within 'footer nav.pagination' do
          assert page.has_selector?("li.previous a[rel=prev][href='/data-protection/find-out-what-data-an-organisation-has-about-you'][title='Llywio i’r rhan flaenorol']",
                                    :text => "Rhan 2 Find out what data an organisation has about you")
          assert page.has_selector?("li.last", :text => "Rydych wedi cyrraedd diwedd y canllaw hwn")
        end
      end
    end
  end

  should "render the print view of a guide correctly" do
    setup_api_responses('data-protection')
    visit "/data-protection/print"

    within "section[role=main]" do
      within first("header") do
        assert page.has_selector?("h1", :text => "Data protection, a guide from GOV.UK")
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

  should "render the print view of a welsh guide correctly" do
    # Note, this is using an english piece of content set to Welsh
    # This is fine because we're testing the page furniture, not the rendering of the content.
    artefact = content_api_response('data-protection')
    artefact["details"]["language"] = "cy"
    content_api_has_an_artefact('data-protection', artefact)

    visit "/data-protection/print"

    within "section[role=main]" do
      within first("header") do
        within('h1') { assert page.has_content?("Data protection, canllaw gan GOV.UK") }
        assert page.has_content?("Nodiadau")
      end

      within "article#the-data-protection-act" do
        assert page.has_selector?("header h1", :text => "Rhan 1: The Data Protection Act")
      end

      within "article#find-out-what-data-an-organisation-has-about-you" do
        assert page.has_selector?("header h1", :text => "Rhan 2: Find out what data an organisation has about you")
      end

      within "article#make-a-complaint" do
        assert page.has_selector?("header h1", :text => "Rhan 3: Make a complaint")
      end

      assert page.has_selector?(".modified-date", :text => "Diweddarwyd diwethaf: 22 Hydref 2012")
    end
  end

  should "allow previewing a guide" do
    content_api_has_a_draft_artefact "data-protection", 1, content_api_response("data-protection")

    visit "/data-protection?edition=1"

    assert_equal 200, page.status_code

    within 'head' do
      assert_equal "Data protection - GOV.UK", find("title").native.text
    end

    within '#content' do
      within first('header') do
        assert page.has_content?("Data protection")
      end

      within '.article-container' do
        within 'aside nav' do
          part_titles = page.all('li').map(&:text).map(&:strip)
          assert_equal ['Part 1: The Data Protection Act', 'Part 2: Find out what data an organisation has about you', 'Part 3: Make a complaint'], part_titles

          assert page.has_link?("Part 2: Find out what data an organisation has about you", :href => "/data-protection/find-out-what-data-an-organisation-has-about-you?edition=1")
          assert page.has_link?("Part 3: Make a complaint", :href => "/data-protection/make-a-complaint?edition=1")
        end

        within 'article' do
          within('header') { assert page.has_content?("Part 1: The Data Protection Act") }

          assert page.has_selector?("ul li", :text => "used fairly and lawfully")

          within 'footer nav.pagination' do
            assert page.has_selector?("li.first", :text => "You are at the beginning of this guide")
            assert page.has_selector?("li.next a[rel=next][href='/data-protection/find-out-what-data-an-organisation-has-about-you?edition=1'][title='Navigate to next part']",
                                      :text => "Part 2 Find out what data an organisation has about you")
          end
        end

        assert page.has_selector?(".print-link a[rel=nofollow][href='/data-protection/print?edition=1']", :text => "Printer entire guide")
      end
    end # within #content
  end
end
