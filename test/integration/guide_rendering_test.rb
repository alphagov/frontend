# encoding: utf-8
require 'integration_test_helper'

class GuideRenderingTest < ActionDispatch::IntegrationTest
  should "render a guide correctly" do
    artefact = setup_api_responses('data-protection')
    visit "/data-protection"

    assert_equal 200, page.status_code

    within 'head', visible: :all do
      assert page.has_selector?("title", text: "Data protection - GOV.UK", visible: :all)
      assert page.has_selector?("link[rel=alternate][type='application/json'][href='/api/data-protection.json']", visible: :all)
      assert_equal(artefact['details']['description'],
                   page.find("meta[@name='description']", visible: false)[:content])
    end

    within '#content' do
      within 'header.page-header' do
        assert page.has_content?("Data protection")
      end

      within '.article-container' do
        within 'aside nav' do
          part_titles = page.all('li').map(&:text).map(&:strip)
          assert_equal ['1. The Data Protection Act', '2. Find out what data an organisation has about you', '3. Make a complaint'], part_titles

          assert page.has_link?("Find out what data an organisation has about you", href: "/data-protection/find-out-what-data-an-organisation-has-about-you")
          assert page.has_link?("Make a complaint", href: "/data-protection/make-a-complaint")
        end

        within('header') { assert page.has_content?("1. The Data Protection Act") }

        assert page.has_selector?("ul li", text: "used fairly and lawfully")

        within 'footer nav.pagination' do
          assert page.has_selector?("li.next a[rel=next][href='/data-protection/find-out-what-data-an-organisation-has-about-you'][title='Navigate to next part']",
                                    text: "Find out what data an organisation has about you")
          assert_equal 1, page.all('li').count
        end

        assert page.has_selector?(".modified-date", text: "Last updated: 22 October 2012")
        assert page.has_selector?(".print-link a[rel=nofollow][href='/data-protection/print']", text: "Print entire guide")
      end
    end # within #content

    assert page.has_selector?("#test-related")

    within('#content aside nav') { click_on "Find out what data an organisation has about you" }

    assert_current_url "/data-protection/find-out-what-data-an-organisation-has-about-you"

    within '#content .article-container' do
      within 'aside nav' do
        part_titles = page.all('li').map(&:text).map(&:strip)
        assert_equal ['1. The Data Protection Act', '2. Find out what data an organisation has about you', '3. Make a complaint'], part_titles

        assert page.has_link?("The Data Protection Act", href: "/data-protection/the-data-protection-act")
        assert page.has_link?("Make a complaint", href: "/data-protection/make-a-complaint")
      end

      within('header') { assert page.has_content?("2. Find out what data an organisation has about you") }

      assert page.has_selector?("h2", text: "When information can be withheld")

      within 'footer nav.pagination' do
        assert page.has_selector?("li.previous a[rel=prev][href='/data-protection/the-data-protection-act'][title='Navigate to previous part']",
                                  text: "The Data Protection Act")
        assert page.has_selector?("li.next a[rel=next][href='/data-protection/make-a-complaint'][title='Navigate to next part']",
                                  text: "Make a complaint")
      end
    end

    within('#content footer') { click_on "Make a complaint" }

    assert_current_url "/data-protection/make-a-complaint"

    within '#content .article-container' do
      within 'aside nav' do
        part_titles = page.all('li').map(&:text).map(&:strip)
        assert_equal ['1. The Data Protection Act', '2. Find out what data an organisation has about you', '3. Make a complaint'], part_titles

        assert page.has_link?("The Data Protection Act", href: "/data-protection/the-data-protection-act")
        assert page.has_link?("Find out what data an organisation has about you", href: "/data-protection/find-out-what-data-an-organisation-has-about-you")
      end

      within('header') { assert page.has_content?("3. Make a complaint") }

      assert page.has_selector?("p strong", text: "ICO helpline")

      within 'footer nav.pagination' do
        assert page.has_selector?("li.previous a[rel=prev][href='/data-protection/find-out-what-data-an-organisation-has-about-you'][title='Navigate to previous part']",
                                  text: "Find out what data an organisation has about you")
        assert_equal 1, page.all('li').count
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
      within 'header.page-header' do
        assert page.has_content?("Data protection")
      end

      within '.article-container' do
        within 'aside nav' do
          part_titles = page.all('li').map(&:text).map(&:strip)
          assert_equal ['1. The Data Protection Act', '2. Find out what data an organisation has about you', '3. Make a complaint'], part_titles

          assert page.has_link?("Find out what data an organisation has about you", href: "/data-protection/find-out-what-data-an-organisation-has-about-you")
          assert page.has_link?("Make a complaint", href: "/data-protection/make-a-complaint")
        end

        within('header') { assert page.has_content?("1. The Data Protection Act") }

        within 'footer nav.pagination' do
          assert page.has_selector?("li.next a[rel=next][href='/data-protection/find-out-what-data-an-organisation-has-about-you'][title='Llywio i’r rhan nesaf']",
                                    text: "Find out what data an organisation has about you")
          assert_equal 1, page.all('li').count
        end

        assert page.has_selector?(".modified-date", text: "Diweddarwyd diwethaf: 22 Hydref 2012")
        assert page.has_selector?(".print-link a[rel=nofollow][href='/data-protection/print']", text: "Tudalen hawdd ei hargraffu")
      end
    end # within #content

    within('#content aside nav') { click_on "Make a complaint" }

    assert_current_url "/data-protection/make-a-complaint"

    within '#content .article-container' do
      within('header') { assert page.has_content?("3. Make a complaint") }

      within 'footer nav.pagination' do
        assert page.has_selector?("li.previous a[rel=prev][href='/data-protection/find-out-what-data-an-organisation-has-about-you'][title='Llywio i’r rhan flaenorol']",
                                  text: "Find out what data an organisation has about you")
        assert_equal 1, page.all('li').count
      end
    end
  end

  should "render the print view of a guide correctly" do
    setup_api_responses('data-protection')
    visit "/data-protection/print"

    within "main[role=main]" do
      within first("header h1") do
        assert page.has_content?("Data protection")
      end

      within "#the-data-protection-act" do
        assert page.has_selector?("header h1", text: "1. The Data Protection Act")
        assert page.has_selector?("ul li", text: "used fairly and lawfully")
      end

      within "#find-out-what-data-an-organisation-has-about-you" do
        assert page.has_selector?("header h1", text: "2. Find out what data an organisation has about you")
        assert page.has_selector?("h2", text: "When information can be withheld")
      end

      within "#make-a-complaint" do
        assert page.has_selector?("header h1", text: "3. Make a complaint")
        assert page.has_selector?("p strong", text: "ICO helpline")
      end

      assert page.has_selector?(".modified-date", text: "Last updated: 22 October 2012")
    end
  end

  should "render the print view of a welsh guide correctly" do
    # Note, this is using an english piece of content set to Welsh
    # This is fine because we're testing the page furniture, not the rendering of the content.
    artefact = content_api_response('data-protection')
    artefact["details"]["language"] = "cy"
    content_api_has_an_artefact('data-protection', artefact)

    visit "/data-protection/print"

    within "main[role=main]" do
      within first("header") do
        within('h1') { assert page.has_content?("Data protection") }
        assert page.has_content?("Nodiadau")
      end

      within "#the-data-protection-act" do
        assert page.has_selector?("header h1", text: "1. The Data Protection Act")
      end

      within "#find-out-what-data-an-organisation-has-about-you" do
        assert page.has_selector?("header h1", text: "2. Find out what data an organisation has about you")
      end

      within "#make-a-complaint" do
        assert page.has_selector?("header h1", text: "3. Make a complaint")
      end

      assert page.has_selector?(".modified-date", text: "Diweddarwyd diwethaf: 22 Hydref 2012")
    end
  end

  should "allow previewing a guide" do
    content_api_has_a_draft_artefact "data-protection", 1, content_api_response("data-protection")

    visit "/data-protection?edition=1"

    assert_equal 200, page.status_code

    within 'head', visible: :all do
      assert page.has_selector?("title", text: "Data protection - GOV.UK", visible: :all)
    end

    within '#content' do
      within 'header.page-header' do
        assert page.has_content?("Data protection")
      end

      within '.article-container' do
        assert page.has_selector?(shared_component_selector('beta_label'))

        within 'aside nav' do
          part_titles = page.all('li').map(&:text).map(&:strip)
          assert_equal ['1. The Data Protection Act', '2. Find out what data an organisation has about you', '3. Make a complaint'], part_titles

          assert page.has_link?("Find out what data an organisation has about you", href: "/data-protection/find-out-what-data-an-organisation-has-about-you?edition=1")
          assert page.has_link?("Make a complaint", href: "/data-protection/make-a-complaint?edition=1")
        end

        within('header') { assert page.has_content?("1. The Data Protection Act") }

        assert page.has_selector?("ul li", text: "used fairly and lawfully")

        within 'footer nav.pagination' do
          assert page.has_selector?("li.next a[rel=next][href='/data-protection/find-out-what-data-an-organisation-has-about-you?edition=1'][title='Navigate to next part']",
                                    text: "Find out what data an organisation has about you")
          assert_equal 1, page.all('li').count
        end

        assert page.has_selector?(".print-link a[rel=nofollow][href='/data-protection/print?edition=1']", text: "Print entire guide")
      end
    end # within #content
  end
end
