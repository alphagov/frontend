class LandingPage < ContentItem
  attr_reader :blocks

  ADDITIONAL_CONTENT_PATH = "lib/data/landing_page_content_items".freeze

  def initialize(content_store_response)
    if content_store_response.dig("details", "blocks")
      super(content_store_response)
    else
      super(
        content_store_response,
        override_content_store_hash: load_additional_content(content_store_response)
      )
    end

    @blocks = (content_store_hash.dig("details", "blocks") || []).map { |block_hash| BlockFactory.build(block_hash) }
  end

private

  # SCAFFOLDING: can be removed (and reference above) when full content items
  # including block details are available from content-store
  def load_additional_content(content_store_response)
    base_path = content_store_response["base_path"]
    file_slug = base_path.split("/").last.gsub("-", "_")
    filename = Rails.root.join("#{ADDITIONAL_CONTENT_PATH}/#{file_slug}.yaml")
    content_hash = content_store_response.to_hash
    return content_hash unless File.exist?(filename)

    content_hash.deep_merge(
      "details" => YAML.load_file(filename),
    )
  end
end
