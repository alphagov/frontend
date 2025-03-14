class SpecialistDocumentPresenter < ContentItemPresenter
  include DateHelper
  include LinkHelper

  def contents
    return [] unless show_contents_list?

    content_item.headers
  end

  def show_protection_type_image?
    protected_food_drink_name? && content_item.protection_type_image.present?
  end

  def show_finder_link?
    content_item.finder.present? && statutory_instrument?
  end

  def important_metadata
    content_item.facets_with_values_from_metadata.inject({}) do |metadata, facet_with_values_from_metadata|
      metadata.merge(facet_with_values_from_metadata[:name] => format_facet_value(facet_with_values_from_metadata))
    end
  end

  def protection_image_path
    "specialist-documents/protected-food-drink-names/#{content_item.protection_type_image['file_name']}"
  end

  def protection_image_alt_text
    I18n.t("formats.specialist_document.protection_image.#{content_item.protection_type_image['alt_text_tag']}")
  end

private

  def show_contents_list?
    content_item.headers.present? && level_two_headings?
  end

  def level_two_headings?
    content_item.headers.any? { |header| header[:level] == 2 }
  end

  def protected_food_drink_name?
    content_item.document_type == "protected_food_drink_name"
  end

  def statutory_instrument?
    content_item.document_type == "statutory_instrument"
  end

  def format_facet_value(facet_with_values_from_metadata)
    case facet_with_values_from_metadata[:type]
    when "date"
      display_date(facet_with_values_from_metadata[:value])
    when "link"
      facet_value_links(facet_with_values_from_metadata[:key], facet_with_values_from_metadata[:value])
    when "preset_text"
      facet_with_values_from_metadata[:value].map { |facet_value| facet_value[:label] }
    else
      facet_with_values_from_metadata[:value]
    end
  end

  def facet_value_links(key, facet_values)
    links = facet_values.map do |facet_value|
      {
        text: facet_value[:label],
        path: filtered_finder_path(key, facet_value[:value]),
      }
    end

    govuk_styled_links_list(links, inverse: true)
  end

  def filtered_finder_path(key, value)
    "#{content_item.finder.base_path}?#{key}%5B%5D=#{value}"
  end
end
