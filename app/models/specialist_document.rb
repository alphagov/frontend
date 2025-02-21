class SpecialistDocument < ContentItem
  attr_reader :continuation_link, :headers, :metadata,
              :protection_type, :will_continue_on

  def initialize(content_store_response)
    super(content_store_response)

    @continuation_link = content_store_hash.dig("details", "metadata", "continuation_link")
    @metadata = content_store_hash["details"]["metadata"]
    @protection_type = content_store_hash.dig("details", "metadata", "protection_type")
    @will_continue_on = content_store_hash.dig("details", "metadata", "will_continue_on")

    @headers = headers_list(content_store_hash.dig("details", "headers"))
  end

  def finder
    @finder ||= Finder.new(content_store_hash.dig("links", "finder", 0))
  end

  def protection_type_image
    return if protection_type.blank?

    all_protection_type_images[protection_type]
  end

private

  def headers_list(headers)
    return if headers.blank?

    headers.map do |header|
      h = {
        href: "##{header['id']}",
        text: header["text"].gsub(/:$/, ""),
        level: header["level"],
      }

      if header["headers"]
        h[:items] = headers_list(header["headers"])
      end

      h
    end
  end

  def all_protection_type_images
    @all_protection_type_images ||= YAML.load_file(Rails.root.join("lib/data/specialist_documents/protected_food_drink_name/images.yaml"))
  end
end
