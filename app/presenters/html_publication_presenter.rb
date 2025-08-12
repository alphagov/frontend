class HtmlPublicationPresenter < ContentItemPresenter
  def hide_from_search_engines?
    return false unless content_item.parent

    PublicationPresenter::PATHS_TO_HIDE.include? content_item.parent.base_path
  end
end
