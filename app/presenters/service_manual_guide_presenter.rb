class ServiceManualGuidePresenter < ContentItemPresenter
  ContentOwner = Struct.new(:title, :href)
  Change = Struct.new(:public_timestamp, :note)

  delegate :links, to: :content_item

  def details
    content_item.content_store_response["details"]
  end

  def header_links
    header_links = details.fetch("header_links", {})
    Array(header_links).map { |h| ActiveSupport::HashWithIndifferentAccess.new(h.transform_keys { |k| k == "title" ? "text" : k }) }
  end

  def content_owners
    content_item.content_owners.map do |content_owner_attributes|
      ContentOwner.new(content_owner_attributes.content_store_response["title"], content_owner_attributes.content_store_response["base_path"])
    end
  end

  def category_title
    category.content_store_response["title"] if category.present?
  end

  def breadcrumbs
    crumbs = [{ title: "Service manual", url: "/service-manual" }]
    crumbs << { title: category.content_store_response["title"], url: category.content_store_response["base_path"] } if category
    crumbs
  end

  def show_description?
    details["show_description"].present?
  end

  def public_updated_at
    timestamp = content_item.content_store_response["public_updated_at"]

    Time.zone.parse(timestamp) if timestamp
  end

  def visible_updated_at
    public_updated_at || updated_at
  end

  def latest_change
    change = change_history.first
    if change.present?
      Change.new(
        visible_updated_at,
        change["note"],
      )
    end
  end

  def previous_changes
    change_history.drop(1).map do |change|
      Change.new(
        Time.zone.parse(change["public_timestamp"]),
        change["note"],
      )
    end
  end

private

  def category
    content_item.topic || content_item.parent
  end

  def change_history
    details.fetch("change_history", {})
  end

  def updated_at
    Time.zone.parse(content_item.content_store_response["updated_at"])
  end
end
