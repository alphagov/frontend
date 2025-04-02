class SpecialistDocument < ContentItem
  include Updatable

  attr_reader :continuation_link, :headers, :metadata,
              :protection_type, :will_continue_on

  def initialize(content_store_response)
    super(content_store_response)

    @continuation_link = content_store_response.dig("details", "metadata", "continuation_link")
    @metadata = content_store_response["details"]["metadata"]
    @protection_type = content_store_response.dig("details", "metadata", "protection_type")
    @will_continue_on = content_store_response.dig("details", "metadata", "will_continue_on")

    @headers = headers_list(content_store_response.dig("details", "headers"))
  end

  def facets_with_values_from_metadata
    @facets_with_values_from_metadata ||= selected_facets.each_with_object([]) do |selected_facet, facets_with_values_from_metadata|
      facets_with_values_from_metadata << main_facet_metadata(selected_facet)

      if selected_facet["type"] == "nested" && metadata[selected_facet["sub_facet_key"]].present?
        facets_with_values_from_metadata << sub_facet_metadata(selected_facet)
      end
    end
  end

  def finder
    @finder ||= Finder.new(content_store_response.dig("links", "finder", 0))
  end

  def protection_type_image
    return if protection_type.blank?

    all_protection_type_images[protection_type]
  end

private

  def main_facet_metadata(selected_facet)
    metadata_facet_value = metadata[selected_facet["key"]]
    if selected_facet["allowed_values"].present?
      value = selected_allowed_values(selected_facet["allowed_values"], metadata_facet_value)
      type = allowed_value_facet_type(selected_facet)
    else
      value = metadata_facet_value
      type = selected_facet["type"]
    end

    {
      key: selected_facet["key"],
      name: selected_facet["name"],
      value:,
      type:,
    }
  end

  def sub_facet_metadata(selected_facet)
    sub_facet_allowed_values = selected_facet["allowed_values"].pluck("sub_facets").flatten
    metadata_sub_facet_value = metadata[selected_facet["sub_facet_key"]]
    sub_facet_values = selected_allowed_values(sub_facet_allowed_values, metadata_sub_facet_value)

    {
      key: selected_facet["sub_facet_key"],
      name: selected_facet["sub_facet_name"],
      main_facet_key: selected_facet["key"],
      type: sub_facet_type(selected_facet),
      value: sub_facet_values,
    }
  end

  # specialist document change history can have a modified date that is
  # slightly different to the public_updated_at, eg milliseconds different
  # this means the direct comparison in updatable gives a false positive
  # Use change_history as specialist-frontend did
  #
  # Can be removed when first_published_at is reliable
  def any_updates?
    change_history.size > 1
  end

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

  def allowed_value_facet_type(facet)
    if %w[text nested].include?(facet["type"]) && facet["filterable"]
      "link"
    elsif %w[text nested].include?(facet["type"])
      "preset_text"
    else
      facet["type"]
    end
  end

  def sub_facet_type(facet)
    facet["filterable"] ? "sub_facet_link" : "sub_facet_text"
  end

  def selected_allowed_values(allowed_values, metadata_facet_values)
    [metadata_facet_values].flatten.map { |metadata_facet_value|
      selected_allowed_value = allowed_values.detect { |allowed_value|
        allowed_value["value"] == metadata_facet_value
      }&.deep_symbolize_keys

      selected_allowed_value&.delete(:sub_facets)
      selected_allowed_value
    }.compact
  end

  def selected_facets
    @selected_facets ||= finder.facets.select { |facet| metadata[facet["key"]].present? }
  end

  def all_protection_type_images
    @all_protection_type_images ||= YAML.load_file(Rails.root.join("lib/data/specialist_documents/protected_food_drink_name/images.yaml"))
  end
end
