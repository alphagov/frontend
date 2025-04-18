class Finder < ContentItem
  attr_reader :facets, :show_metadata_block, :show_table_of_contents_list

  def initialize(content_store_response)
    super(content_store_response)

    @facets = content_store_response.dig("details", "facets")
    @show_metadata_block = content_store_response.dig("details", "show_metadata_block")
    @show_table_of_contents_list = content_store_response.dig("details", "show_table_of_contents_list")
  end
end
