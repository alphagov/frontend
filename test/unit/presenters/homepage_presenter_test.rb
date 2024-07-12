require "test_helper"

class HomepagePresenterTest < ActiveSupport::TestCase
  setup do
    @content_item = {
      "links" => {
        "popular_links" => [
          {
            "details" => {
              "link_items" => [
                {
                  "title" => "Some title",
                  "url" => "/some/path",
                },
              ],
            },
          },
        ],
      },
    }
    @subject = HomepagePresenter.new(@content_item)
  end

  context "#links" do
    should "return links" do
      assert_equal @content_item["links"], @subject.links
    end
  end

  context "#popular_links" do
    context "when popular links in the content item" do
      should "memoize popular links" do
        expected_popular_links = @subject.popular_links
        @content_item["links"].delete("popular_links")
        assert_equal expected_popular_links, @subject.popular_links
      end

      should "return popular links from the content item" do
        expected_popular_links = @content_item
          .dig("links", "popular_links", 0, "details", "link_items")
          .collect(&:with_indifferent_access)
        assert_equal expected_popular_links, @subject.popular_links
      end
    end

    context "when popular links not in the content item" do
      setup do
        @content_item["links"].delete("popular_links")
      end

      should "return popular links from the locale file" do
        expected_popular_links = I18n.t("homepage.index.popular_links")
          .collect(&:with_indifferent_access)
        assert_equal expected_popular_links, @subject.popular_links
      end
    end
  end
end
