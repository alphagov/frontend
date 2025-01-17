class SpecialistDocumentPresenter < ContentItemPresenter
  def show_contents_list?
    content_item.headers.present? && level_two_headings?
  end

private

  def level_two_headings?
    content_item.headers.any? { |header| header[:level] == 2 }
  end
end
