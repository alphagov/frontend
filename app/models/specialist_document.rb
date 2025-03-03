class SpecialistDocument < ContentItem
  include Updatable
  include DateHelper
  include LinkHelper

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

  def display_metadata
    @display_metadata = selected_facets.inject({}) do |display_metadata, selected_facet|
      metadata_facet_values = [metadata[selected_facet["key"]]].flatten
      metadata_display_value = format_facet_values(metadata_facet_values, selected_facet)
      display_metadata.merge(selected_facet["name"] => metadata_display_value)
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

  def format_facet_values(metadata_facet_values, selected_facet)
    return metadata_facet_values.map { |value| display_date(value) } if selected_facet["type"] == "date"
    return format_facet_text(metadata_facet_values, selected_facet) if selected_facet["type"] == "text"

    metadata_facet_values
  end

  def format_facet_text(metadata_facet_values, selected_facet)
    return metadata_facet_values if selected_facet["allowed_values"].blank?

    metadata_facet_values.map do |metadata_facet_value|
      friendly_facet_text_with_link(metadata_facet_value, selected_facet)
    end
  end

  def friendly_facet_text_with_link(metadata_facet_value, selected_facet)
    selected_allowed_value = selected_facet["allowed_values"].detect do |av|
      av["value"] == metadata_facet_value
    end

    return metadata_facet_value unless selected_allowed_value
    return selected_allowed_value["label"] unless selected_facet["filterable"]

    govuk_styled_link(
      selected_allowed_value["label"],
      path: facet_link_path(selected_facet["key"], selected_allowed_value),
      inverse: true,
    )
  end

  def facet_link_path(key, allowed_value)
    query_params = { "#{key}[]" => allowed_value["value"] }

    "#{finder.base_path}?#{query_params.to_query}"
  end

  def selected_facets
    @selected_facets ||= finder.facets.select { |facet| metadata[facet["key"]].present? }
  end

  def all_protection_type_images
    @all_protection_type_images ||= YAML.load_file(Rails.root.join("lib/data/specialist_documents/protected_food_drink_name/images.yaml"))
  end
end
