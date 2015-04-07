class ScopedSearchResultsPresenter < SearchResultsPresenter

  def to_hash
    super.merge({
      is_scoped?: true,
      scope_title: scope_title,
    })
  end

private

  def filter_fields
  end

  def scope_title
    search_response[:scope][:title]
  end

end
