module Services
  def self.search_api
    puts "In Services"
    @search_api = GdsApi::Search.new(
      Plek.find("search-api"),
    )
    puts "Out Services"
  end
end
