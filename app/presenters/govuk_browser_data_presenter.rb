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
        content: wrapped_table_for("#{table[:filename_base]}-#{key}"),
      }
    end
  end

private

  def wrapped_table_for(name)
    table = @view_context.render("govuk_publishing_components/components/table", content_item.table_data_from("#{name}.csv"))
    "<div class=\"govuk-browser-data-tabbed-table\">#{table}</div>".html_safe
  end
end
