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

  def content_owners
    Array(@content_item.content_owners).map do |data|
      {
        title: data.title,
        href: data.base_path,
      }
    end
  end

  def community_title
    topic_related_communities_title(@content_item.content_owners)
  end

  def community_links
    content_owners.map do |content_owner|
      sanitize(link_to(content_owner[:title], content_owner[:href], class: "govuk-link"))
    end
  end

  def email_alert_signup_link
    "/email-signup?link=#{@content_item.base_path}"
  end

private

  def list_of_links(items)
    content_tag(:ul, class: "govuk-list") do
      items.each do |i|
        concat content_tag(:li, link_to(i["title"], i["base_path"], class: "govuk-link"))
      end
    end
  end

  def topic_related_communities_title(communities)
    if communities.length == 1
      "Join the #{communities.first.title}"
    else
      "Join the community"
    end
  end
end
