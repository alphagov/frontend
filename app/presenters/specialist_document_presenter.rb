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
    facet_values = facet_with_values_from_metadata[:value]
    case facet_with_values_from_metadata[:type]
    when "date"
      display_date(facet_values)
    when "link"
      facet_values.map { |facet_value| facet_value_link(facet_with_values_from_metadata, facet_value) }
    when "sub_facet_link"
      facet_values.map { |facet_value| sub_facet_value_link(facet_with_values_from_metadata, facet_value) }
    when "preset_text"
      facet_values.map { |facet_value| facet_value[:label] }
    when "sub_facet_text"
      facet_values.map { |facet_value| sub_facet_label(facet_value) }
    else
      facet_values
    end
  end

  def facet_value_link(assigned_facet, facet_value)
    query_params = { "#{assigned_facet[:key]}[]" => facet_value[:value] }
    finder_link(facet_value[:label], query_params)
  end

  def sub_facet_value_link(assigned_facet, facet_value)
    query_params = {
      "#{assigned_facet[:key]}[]" => facet_value[:value],
      "#{assigned_facet[:main_facet_key]}[]" => facet_value[:main_facet_value],
    }
    finder_link(sub_facet_label(facet_value), query_params)
  end

  def sub_facet_label(facet_value)
    "#{facet_value[:main_facet_label]} - #{facet_value[:label]}"
  end

  def finder_link(label, query_params)
    path = "#{content_item.finder.base_path}?#{query_params.to_query}"
    govuk_styled_link(label, path:, inverse: true)
  end
end
