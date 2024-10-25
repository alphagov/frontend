module LinkHelper
  def govuk_styled_link(text, path: nil, inverse: false, card_link: false)
    return text if path.blank?

    classes = "govuk-link"
    classes << " govuk-link--inverse" if inverse
    classes << " app-b-card__textbox-link" if card_link

    "<a href='#{path}' class='#{classes}'>#{text}</a>".html_safe
  end
end
