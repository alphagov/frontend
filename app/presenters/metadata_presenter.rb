class MetadataPresenter
  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def metadata_component_options
    metadata = content_item.publisher_metadata
    format_metadata_dates(metadata)
    format_metadata_links(metadata)
    metadata
  end

private

  def format_metadata_dates(metadata)
    metadata[:first_published] = display_date(metadata[:first_published])
    metadata[:last_updated] = display_date(metadata[:last_updated])
  end

  def format_metadata_links(metadata)
    metadata[:from] = metadata[:from].map { |link| link_to_organisation(link) }
  end

  def display_date(timestamp, format = "%-d %B %Y")
    I18n.l(Time.zone.parse(timestamp), format:, locale: "en") if timestamp
  end

  def link_to_organisation(link)
    ActionController::Base.helpers.link_to(link["title"], link["base_path"], class: "govuk-link")
  end
end
