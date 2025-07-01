class DocumentCollectionPresenter < ContentItemPresenter
  def headers_for_contents_list_component
    headers = contents_list_headings_with_group_headings

    return [] unless headers.present? && headers.level_two_headers?

    ContentsOutlinePresenter.new(headers).for_contents_list_component
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
          document_type: I18n.t(
            "formats.#{document.document_type}.name",
            count: 1,
            default: nil,
          ),
        },
      }
    end
  end

private

  def contents_list_headings_with_group_headings
    exclude_nested_headings
    all_headers = content_item.headers + content_item.groups_with_items.map do |group|
      {
        "id" => group.id,
        "level" => 2,
        "text" => group.title,
      }
    end

    ContentsOutline.new(all_headers) if all_headers.any?
  end

  def exclude_nested_headings
    content_item.headers.each do |header|
      header.delete("headers") unless header["headers"].nil?
    end
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
