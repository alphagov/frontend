class GovukBrowserDataPresenter < ContentItemPresenter
  def initialize(content_item, view_context)
    super(content_item)
    @view_context = view_context
  end

  def page_title_options
    {
      heading_text: content_item.title,
      lead_paragraph: content_item.description,
    }
  end

  def tabs(table)
    GovukBrowserData::TABLE_TABS.map do |key, label|
      {
        id: "#{table[:filename_base]}-#{key}",
        label:,
        content: @view_context.render("govuk_publishing_components/components/table", content_item.table_data_from("#{table[:filename_base]}-#{key}.csv")),
      }
    end
  end
end
