class DocumentCollectionPresenter < ContentItemPresenter
  def groups_as_content_list
    content_item.groups.map do |group|
      {
        href: "##{group.id}",
        text: group.title,
      }
    end
  end

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
