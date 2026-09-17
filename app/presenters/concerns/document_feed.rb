module DocumentFeed
  def document_feed_options
    {
      email_signup_link: "/email-signup?link=#{content_item.base_path}",
      email_signup_link_text: "Get email updates",
      heading_text: "Latest updates",
      items: feed_items,
      see_all_items_link: "/search/all?order=updated-newest&topical_events%5B%5D=#{content_item.base_path.split('/').last}",
      see_all_items_link_text: "See more updates",
    }
  end

  def feed_items
    @feed_items ||= FeedService.new(search_options: { filter_topical_events: content_item.base_path.split("/").last }).fetch_related_documents_with_format
  end
end
