class FindLocalCouncilPresenter < ContentItemPresenter
  def use_contextual_components?
    true
  end

  def page_title_options
    super.merge({
      heading_text: I18n.t("formats.local_transaction.find_council"),
      lead_paragraph: nil,
    })
  end
end
