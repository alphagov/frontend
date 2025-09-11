class DocumentCollectionPresenter < ContentItemPresenter
  include ContentsList

  def displayable_collection_groups
    content_item.collection_groups.select do |group|
      non_withdrawn_documents(group).any?
    end
  end

  def group_as_document_list(group)
    non_withdrawn_documents(group).map do |document|
      {
        link: {
          text: document.title,
          path: document.base_path,
        },
        metadata: {
          public_updated_at: sanitised_updated_at(document),
          document_type: I18n.t(
            "formats.#{document.document_type}.name",
            count: 1,
            default: nil,
          ),
        },
      }
    end
  end

  def collection_groups_headers
    displayable_collection_groups.map do |group|
      {
        "id" => group.id,
        "level" => 2,
        "text" => group.title,
      }
    end
  end

  def show_email_signup_link?
    content_item.taxonomy_topic_email_override_base_path.present? && I18n.locale == :en
  end

private

  def non_withdrawn_documents(group)
    group.documents.reject { |doc| doc.content_store_response["withdrawn"] }
  end

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
