class TravelAdvicePresenter < ContentItemPresenter
  def page_title
    if content_item.part_slug.blank? || content_item.first_part?
      super
    else
      "#{content_item.current_part_title} - #{super}"
    end
  end

  # FIXME: Update publishing app UI and remove from content
  # Change description is used as "Latest update" but isn't labelled that way
  # in the publisher. The frontend didn't add this label before.
  # This led to users appending (in a variety of formats)
  # "Latest update:" to the start of the change description. The frontend now
  # has a latest update label, so we can strip this out.
  # Avoids: "Latest update: Latest update - ..."
  def latest_update
    content_item.change_description.sub(/^Latest update:?\s-?\s?/i, "").tap do |latest|
      latest[0] = latest[0].capitalize if latest.present?
    end
  end
end
