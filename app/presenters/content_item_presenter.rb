class ContentItemPresenter
  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  PASS_THROUGH_KEYS = %i[
    base_path content_id details description first_published_at locale title
  ].freeze

  PASS_THROUGH_KEYS.each do |key|
    define_method key do
      content_item[key.to_s]
    end
  end

  def slug
    URI.parse(base_path).path.sub(%r{\A/}, "")
  end
end
