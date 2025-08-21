class History < FlexiblePage
  def breadcrumbs
    super << {
      title: "History of the UK Government",
      url: "/government/history",
    }
  end

private

  def default_flexible_sections
    [
      {
        type: "page_title",
        context: "History",
        heading_text: title,
        # lead_paragraph: fake_lp,
      },
      {
        type: "rich_content",
        contents_list: (content_store_response.dig("details", "headers") || []).map { |header| header.except("headers") },
        govspeak: body,
        image: {
          alt: content_store_response.dig("details", "sidebar_image", "caption"),
          src: content_store_response.dig("details", "sidebar_image", "url"),
        },
      },
    ]
  end

  # def fake_lp
  #   'In this section you can read short biographies of <a href="#notable-people" class="govuk-link">notable people</a> and explore the history of <a href="#government-buildings" class="govuk-link">government buildings</a>. You can also search our <a href="#documents-records" class="govuk-link">online records</a> and read <a href="#articles-and-blog-posts" class="govuk-link">articles and blog posts</a> by historians.'.html_safe
  # end
end
