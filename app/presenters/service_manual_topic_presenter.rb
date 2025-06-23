class ServiceManualTopicPresenter < ContentItemPresenter
  include ActionView::Helpers
  include ActionView::Context

  def breadcrumbs
    [
      { title: "Service manual", url: "/service-manual" },
    ]
  end

  def sections
    @content_item.groups_with_links.map do |group|
      {
        heading: {
          text: group[:name],
        },
        summary: {
          text: group[:description],
        },
        content: {
          html: list_of_links(group[:items]),
        },
      }
    end
  end

private

  def list_of_links(items)
    content_tag(:ul, class: "govuk-list") do
      items.each do |i|
        concat content_tag(:li, link_to(i["title"], i["base_path"], class: "govuk-link"))
      end
    end
  end
end
