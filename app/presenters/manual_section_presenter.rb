class ManualSectionPresenter < ContentItemPresenter
  include ManualBreadcrumbs
  include ManualMetadata

  MOJ_ORGANISATION_CONTENT_ID = "dcc907d6-433c-42df-9ffb-d9c68be5dc4d".freeze

  def initialize(content_item, request = nil)
    super(content_item)
    @request = request
  end

  def main_breadcrumbs
    crumbs = breadcrumb_selector
    return unless crumbs

    crumbs << {
      title: content_item.manual_content_item.title,
      url: content_item.manual_content_item.base_path,
    }
  end

  def contents_outline_presenter
    ContentsOutlinePresenter.new(content_item.contents_outline)
  end

  def document_heading
    [content_item.content_store_response.dig("details", "section_id"), content_item.title].compact.join(" - ")
  end

  def show_contents_list?
    content_item.organisations.first.content_id == MOJ_ORGANISATION_CONTENT_ID
  end
end
