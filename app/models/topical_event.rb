class TopicalEvent < FlexiblePage

private

  def default_flexible_sections
    [
      {
        type: "page_title",
        heading_text: title,
        lead_paragraph: description,
      },
      {
        type: "rich_content",
        contents_list: (content_store_response.dig("details", "headers") || []).map { |header| header.except("headers") },
        govspeak: body,
      },
      {
        type: "featured",
        ordered_featured_documents: content_store_response.dig("details", "ordered_featured_documents")
      },
      {
        type: "feed",
        feed_heading_text: "Latest",
        email_signup_link: "/something",
        items: fetch_related_documents_with_format,
        see_all_items_link: "/search/all",
        share_links_heading_text: "Follow us",
        share_links: social_media_links
      },
      {
        type: "organisations",
        organisations: organisation_map,
      }
    ]
  end

  def organisation_map
    linked("organisations").map do |org|
      {
        name: org.title,
        url: org.base_path,
        brand: org.brand,
        crest: org.logo.crest,
      }
    end
  end

  def social_media_links
    content_store_response.dig("details", "social_media_links")&.map do |social_media_link|
      {
        href: social_media_link["href"],
        text: social_media_link["title"],
        icon: social_media_link["service_type"],
      }
    end
  end

  def fields
    %w[display_type
      title
      link
      public_timestamp
      format
      content_store_document_type
      description
      content_id
      organisations
      document_collections].freeze
  end

  def slug
    base_path.split('/').last
  end

  def default_search_options
    { filter_topical_events: [slug],
      count: 5,
      order: "-public_timestamp",
      fields: }
  end

  def fetch_related_documents_with_format
    search_response = GdsApi.search.search(default_search_options)
    format_results(search_response)
  end

  def display_type(document)
    key = document.fetch("display_type", nil) || document.fetch("content_store_document_type", "")
    key.humanize
  end

  def format_results(search_response)
    search_response["results"].map do |document|
      {
        link: {
          text: document["title"],
          path: document["link"],
        },
        metadata: {
          # public_updated_at: Time.zone.parse(document["public_timestamp"]),
          document_type: display_type(document),
        },
      }
    end
  end
end
