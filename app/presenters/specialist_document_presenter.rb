class SpecialistDocumentPresenter < ContentItemPresenter
  def show_contents_list?
    content_item.headers.present? && level_two_headings?
  end

  def show_finder_link?
    content_item.finder.present? && statutory_instrument?
  end

private

  def level_two_headings?
    content_item.headers.any? { |header| header[:level] == 2 }
  end

  def statutory_instrument?
    content_item.document_type == "statutory_instrument"
  end
end
