class SpecialistDocumentPresenter < ContentItemPresenter
  def contents
    return [] unless show_contents_list?

    content_item.headers
  end

private

  attr_reader :view_context

  def show_contents_list?
    content_item.headers.present? && level_two_headings?
  end

  def level_two_headings?
    content_item.headers.any? { |header| header[:level] == 2 }
  end
end
