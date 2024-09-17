class TravelAdvicePresenter < ContentItemModelPresenter
  attr_reader :content_item

  def page_title
    if content_item.part_slug.blank? || content_item.first_part?
      super
    else
      "#{content_item.current_part_title} - #{super}"
    end
  end
end
