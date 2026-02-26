class AtomFeedEntryPresenter
  attr_reader :feed_item

  def initialize(feed_item)
    @feed_item = feed_item
  end

  def id
    "#{url}##{updated.rfc3339}"
  end

  def url
    Plek.new.website_root + feed_item[:link][:path]
  end

  def updated
    feed_item[:metadata][:public_updated_at]
  end

  def title
    if display_type.present?
      "#{display_type}: #{feed_item[:link][:text]}"
    else
      feed_item[:link][:text]
    end
  end

  def description
    feed_item[:metadata][:description]
  end

  def display_type
    feed_item[:metadata][:document_type]
  end
end
