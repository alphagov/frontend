class LandingPage < ContentItem
  attr_reader :blocks

  def initialize(content_store_response)
    super(content_store_response.deep_merge(load_additional_content(content_store_response["base_path"])))

    @blocks = @content_store_response.dig("details", "blocks").map { |block_hash| BlockFactory.build(block_hash) }
  end

private

  def load_additional_content(base_path)
    file_slug = base_path.split("/").last.gsub("-", "_")
    filename = Rails.root.join("lib/data/landing_page_content_items/#{file_slug}.yaml")
    return { "details" => {} } unless File.exist?(filename)

    { "details" => YAML.load(File.read(filename)) }
  end
end
