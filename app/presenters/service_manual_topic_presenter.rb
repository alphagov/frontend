class ServiceManualTopicPresenter < ContentItemPresenter
  include ActionView::Helpers
  include ActionView::Context

  def breadcrumbs
    [
      { title: "Service manual", url: "/service-manual" },
    ]
  end

  def display_as_accordion?
    @content_item.groups.count > 2 && @content_item.visually_collapsed?
  end

  def accordion_sections
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

  def sections
    @content_item.groups_with_links.map do |group|
      {
        heading: group[:name],
        summary: group[:description],
        html: list_of_links(group[:items]),
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
