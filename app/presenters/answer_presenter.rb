class AnswerPresenter < ContentItemPresenter
  def use_contextual_components?
    true
  end

  def page_title_options
    super.merge({
      lead_paragraph: nil,
    })
  end
end
