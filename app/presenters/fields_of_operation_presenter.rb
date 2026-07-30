class FieldsOfOperationPresenter < ContentItemPresenter
  def page_title_options
    super.merge!({ context: I18n.t("formats.fields_of_operation.context"), context_locale: I18n.locale })
  end
end
