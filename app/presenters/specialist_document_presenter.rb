class SpecialistDocumentPresenter < ContentItemPresenter
  include DateHelper
  include LinkHelper

  def initialize(content_item, view_context = nil)
    super(content_item)

    @view_context = view_context
  end

  def show_contents_list?
    content_item.headers.present? && level_two_headings?
  end

  def show_protection_type_image?
    protected_food_drink_name? && content_item.protection_type_image.present?
  end

  def show_finder_link?
    content_item.finder.present? && statutory_instrument?
  end

  def facet_metadata
    metadata = {}
    content_item.facet_values.each do |facet_value|
      metadata[facet_value[:name]] = if facet_value[:type] == "date"
                                       view_context.display_date(facet_value[:value])
                                     elsif facet_value[:type] == "text" && facet_value[:value].is_a?(String) && facet_value[:filterable] == true
                                       view_context.govuk_styled_link(facet_value[:label], facet_value[:value], inverse: true)
                                     elsif facet_value[:type] == "text" && facet_value[:value].is_a?(Array)
                                       facet_value[:value].pluck(:label).join(", ")
                                     else
                                       facet_value[:value]
                                     end
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

  attr_reader :view_context

  def level_two_headings?
    content_item.headers.any? { |header| header[:level] == 2 }
  end

  def protected_food_drink_name?
    content_item.document_type == "protected_food_drink_name"
  end

  def statutory_instrument?
    content_item.document_type == "statutory_instrument"
  end
end
