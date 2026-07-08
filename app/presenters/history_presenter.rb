class HistoryPresenter < ContentItemPresenter
  def breadcrumbs
    default_breadcrumbs + [
      {
        title: "History of the UK Government",
        url: "/government/history",
      },
    ]
  end
end
