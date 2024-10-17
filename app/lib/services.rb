module Services
  def self.search_api
    Rails.logger.debug "In Services"
    @search_api = GdsApi::Search.new(
      Plek.find("search-api"),
    )
    Rails.logger.debug "Out Services"
  end
end
