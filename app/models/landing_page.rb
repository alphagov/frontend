class LandingPage < ContentItem
  attr_reader :blocks

  ADDITIONAL_CONTENT_PATH = "lib/data/landing_page_content_items".freeze

  def initialize(content_store_response)
    if content_store_response.dig("details", "blocks")
      super(content_store_response)
    else
      super(content_store_response.deep_merge(load_additional_content(content_store_response["base_path"])))
    end

    @blocks = (@content_store_response.dig("details", "blocks") || []).map { |block_hash| BlockFactory.build(block_hash) }
  end

private

  # SCAFFOLDING: can be removed (and reference above) when full content items
  # including block details are available from content-store
  def load_additional_content(base_path)
    file_slug = base_path.split("/").last.gsub("-", "_")
    filename = Rails.root.join("#{ADDITIONAL_CONTENT_PATH}/#{file_slug}.yaml")
    return { "details" => {} } unless File.exist?(filename)

    { "details" => YAML.load_file(filename, permitted_classes: [Date]) }
  end
end
