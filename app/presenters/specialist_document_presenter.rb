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
    return assigned_facet[:values].map { |date| display_date(date) } if assigned_facet[:type] == "date"
    return assigned_facet[:values].map { |facet_value| format_nested_sub_facet(assigned_facet, facet_value) } if assigned_facet[:type] == "nested_sub_facet"

    assigned_facet[:values].map { |facet_value| format_facet(assigned_facet, facet_value) }
  end

  def format_facet(assigned_facet, facet_value)
    label = facet_label(facet_value)
    return label unless assigned_facet[:link?]

    query_params = { assigned_facet[:key] => facet_value[:value] }
    facet_value_link(label, query_params)
  end

  def format_nested_sub_facet(assigned_facet, facet_value)
    label = sub_facet_label(facet_value)
    return label unless assigned_facet[:link?]

    query_params = {
      assigned_facet[:key] => facet_value[:value],
      assigned_facet[:main_facet_key] => facet_value[:main_facet_value],
    }
    facet_value_link(label, query_params)
  end

  def facet_label(facet_value)
    facet_value.is_a?(Hash) ? facet_value[:label] : facet_value
  end

  def sub_facet_label(facet_value)
    "#{facet_value[:main_facet_label]} - #{facet_value[:label]}"
  end

  def facet_value_link(label, query_params)
    path = "#{content_item.finder.base_path}?#{query_params.to_query}"
    govuk_styled_link(label, path:, inverse: true)
  end
end
