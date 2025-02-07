class SpecialistDocument < ContentItem
  include Updatable

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

  def facet_values
    @facet_values ||= selected_facets.map do |selected_facet|
      f = {
        key: selected_facet["key"],
        name: selected_facet["name"],
      }

      metadata_facet_value = metadata[selected_facet["key"]]
      f[:value] = if selected_facet["allowed_values"].present?
                    allowed_value(selected_facet["allowed_values"], metadata_facet_value)
                  else
                    metadata_facet_value
                  end

      f[:type] = if link?(selected_facet, f[:value])
                   "link"
                 else
                   selected_facet["type"]
                 end

      f
    end
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

  def link?(facet, permitted_value)
    facet["type"] == "text" &&
      permitted_value.is_a?(Array) &&
      facet["filterable"] == true
  end

  def allowed_value(allowed_values, metadata_facet_value)
    allowed_values.select do |allowed_value|
      next unless allowed_value["value"] == metadata_facet_value ||
        metadata_facet_value.is_a?(Array) &&
          allowed_value["value"].in?(metadata_facet_value)

      allowed_value.deep_symbolize_keys!
    end
  end

  def selected_facets
    @selected_facets ||= finder.facets.select { |facet| metadata[facet["key"]] && metadata[facet["key"]].present? }
  end

  def all_protection_type_images
    @all_protection_type_images ||= YAML.load_file(Rails.root.join("lib/data/specialist_documents/protected_food_drink_name/images.yaml"))
  end
end
