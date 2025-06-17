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
        metadata: {
          public_updated_at: sanitised_updated_at(document),
        },
      }
    end
  end

private

  def sanitised_updated_at(document)
    disallowed_document_types = %w[answer
                                   completed_transaction
                                   guide
                                   local_transaction
                                   place
                                   simple_smart_answer
                                   transaction
                                   smart_answer]

    return nil if disallowed_document_types.include?(document.document_type)

    document.public_updated_at&.then { |time| Time.zone.parse(time) }
  end
end
