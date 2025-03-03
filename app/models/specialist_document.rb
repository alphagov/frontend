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
      label_and_values = facet_label_and_values(metadata_facet_values, selected_facet)
      type = link?(selected_facet, label_and_values) ? "link" : selected_facet["type"]

      display_metadata.merge(selected_facet["name"] => format_facet_values(type, label_and_values, selected_facet["key"]))
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

  def facet_label_and_values(metadata_facet_values, selected_facet)
    return metadata_facet_values if selected_facet["allowed_values"].blank?

    selected_allowed_values(selected_facet["allowed_values"], metadata_facet_values)
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

  def selected_allowed_values(allowed_values, metadata_facet_values)
    allowed_values.select do |allowed_value|
      allowed_value["value"].in? metadata_facet_values
    end
  end

  def format_facet_values(type, values, key)
    return values.map { |value| display_date(value) } if type == "date"
    return facet_value_links(key, values) if type == "link"

    values
  end

  def facet_value_links(key, values)
    links = values.map do |facet_value|
      {
        text: facet_value["label"],
        path: filtered_finder_path(key, facet_value["value"]),
      }
    end

    govuk_styled_links_list(links, inverse: true)
  end

  def filtered_finder_path(key, value)
    "#{finder.base_path}?#{key}%5B%5D=#{value}"
  end

  def selected_facets
    @selected_facets ||= finder.facets.select { |facet| metadata[facet["key"]].present? }
  end

  def all_protection_type_images
    @all_protection_type_images ||= YAML.load_file(Rails.root.join("lib/data/specialist_documents/protected_food_drink_name/images.yaml"))
  end
end
