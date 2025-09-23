class FatalityNotice < ContentItem
  include EmphasisedOrganisations
  include Updatable

  def field_of_operation
    linked("field_of_operation").first
  end

  def contributors
    organisations_ordered_by_emphasis + linked("people")
  end

  def context
    I18n.t("formats.fatality_notice.operations_in", location: field_of_operation.try(:title))
  end
end
