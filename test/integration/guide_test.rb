require 'integration_test_helper'

class GuideTest < ActionDispatch::IntegrationTest
  context "with a multi-part guide" do
    setup do
      @content_item ||= content_store_has_example_item_not_tagged_to_taxon('/foo', schema: 'guide')
    end

    should "render correctly" do
      visit "/foo"

      assert_equal 200, page.status_code
      page.assert_title "#{@content_item['title']} - GOV.UK"

      within 'head', visible: :all do
        assert_equal(@content_item['description'],
                     page.find("meta[@name='description']", visible: false)[:content])
      end

      within '#content' do
        within 'header.page-header' do
          assert page.has_content? @content_item['title']
        end

        within '.article-container' do
          href = "#{@content_item['base_path']}/print"
          assert page.has_selector?(".print-link a[rel=nofollow][href='#{href}']", text: "Print entire guide")
        end
      end

      assert_parts_navigation_is_correct(@content_item)
      assert_breadcrumb_rendered
      assert_related_items_rendered
    end

    should "render the print view correctly" do
      visit "/foo/print"

      parts = @content_item['details']['parts']

      within "main[role=main]" do
        within first("header h1") do
          assert page.has_content? @content_item['title']
        end

        assert page.has_selector?("header h1", text: "1. #{parts[0]['title']}")
        assert page.html.include? parts[0]['body']
        assert page.has_selector?("header h1", text: "2. #{parts[1]['title']}")
        assert page.html.include? parts[1]['body']
        assert page.has_selector?("header h1", text: "3. #{parts[2]['title']}")
        assert page.html.include? parts[2]['body']
        assert page.has_selector?("header h1", text: "4. #{parts[3]['title']}")
        assert page.html.include? parts[3]['body']
      end
    end
  end

  context "with a single-page guide" do
    setup do
      @content_item ||= content_store_has_example_item_not_tagged_to_taxon('/foo', schema: 'guide', example: 'single-page-guide')
    end

    should "render correctly" do
      visit "/foo"

      assert_equal 200, page.status_code

      assert page.has_selector?("#wrapper #content.single-page")
      within '#wrapper #content .article-container' do
        assert page.has_no_xpath?("./aside")
        assert page.has_no_xpath?("./article/div/header")
        assert page.has_no_xpath?("./article/div/footer")
      end
    end
  end
end
