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
    content_item.assigned_facets.inject({}) do |metadata, assigned_facet|
      metadata.merge(assigned_facet[:name] => format_facet_value(assigned_facet))
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

  def format_facet_value(assigned_facet)
    case assigned_facet[:type]
    when "date"
      display_date(assigned_facet[:value])
    when "link"
      facet_value_link(assigned_facet[:key], assigned_facet[:value])
    when "preset_text"
      assigned_facet[:value].map { |facet_value| facet_value[:label] }
    else
      assigned_facet[:value]
    end
  end

  def facet_value_link(key, facet_values)
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
