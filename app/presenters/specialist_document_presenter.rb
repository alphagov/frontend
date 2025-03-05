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
    metadata = {}
    content_item.facet_values.each do |facet_value|
      metadata[facet_value[:name]] = format_facet_value(facet_value[:type],
                                                        facet_value[:value],
                                                        facet_value[:key])
    end

    metadata
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

  def format_facet_value(type, value, key)
    case type
    when "date"
      display_date(value)
    when "link"
      links = value.map do |v|
        {
          text: v[:label],
          path: filtered_finder_path(key, v[:value]),
        }
      end

      govuk_styled_links_list(links, inverse: true)
    when "preset_text"
      value.map { |v| v[:label] }.join(", ")
    else
      value
    end
  end

  def filtered_finder_path(key, value)
    "#{content_item.finder.base_path}?#{key}%5B%5D=#{value}"
  end
end
