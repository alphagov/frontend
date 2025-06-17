class DocumentCollectionPresenter < ContentItemPresenter
  def group_as_document_list(group)
    group.documents.map do |document|
      {
        link: {
          text: document.title,
          path: document.base_path,
        },
      }
    end
  end
end
