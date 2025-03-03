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

  def facet_values
    @facet_values ||= selected_facets.map do |selected_facet|
      metadata_facet_value = metadata[selected_facet["key"]]
      label_and_values = facet_label_and_values(metadata_facet_value, selected_facet)
      type = link?(selected_facet, label_and_values) ? "link" : selected_facet["type"]

      {
        key: selected_facet["key"],
        name: selected_facet["name"],
        value: label_and_values,
        type:,
      }
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

  def facet_label_and_values(metadata_facet_value, selected_facet)
    return metadata_facet_value if selected_facet["allowed_values"].blank?

    selected_allowed_values(selected_facet["allowed_values"], metadata_facet_value)
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

  def link?(facet, permitted_value)
    facet["type"] == "text" &&
      permitted_value.is_a?(Array) &&
      facet["filterable"] == true
  end

  def selected_allowed_values(allowed_values, metadata_facet_value)
    allowed_values.select do |allowed_value|
      next unless allowed_value["value"].in?([metadata_facet_value].flatten)

      allowed_value.deep_symbolize_keys!
    end
  end

  def selected_facets
    @selected_facets ||= finder.facets.select { |facet| metadata[facet["key"]].present? }
  end

  def all_protection_type_images
    @all_protection_type_images ||= YAML.load_file(Rails.root.join("lib/data/specialist_documents/protected_food_drink_name/images.yaml"))
  end
end
