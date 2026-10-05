class Recent
  RESULTS_SIZE = 10

  def feed_items
    @feed_items ||= FeedService.new(
      search_options: { count: RESULTS_SIZE },
    ).fetch_related_documents_with_format
  end
end
