require "test_helper"

class PromotionPresenterTest < ActiveSupport::TestCase
  def subject(content_item)
    PromotionPresenter.new(content_item.deep_stringify_keys!)
  end

  test "#organ_donor?" do
    assert subject(category: "organ_donor").organ_donor?
    refute subject(category: "mot_reminder").organ_donor?
  end

  test "#mot_reminder?" do
    assert subject(category: "mot_reminder").mot_reminder?
    refute subject(category: "organ_donor").mot_reminder?
  end

  test "#url" do
    assert_equal "https://example.org", subject(url: "https://example.org").url
  end
end
