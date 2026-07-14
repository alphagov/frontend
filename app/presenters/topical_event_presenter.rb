class TopicalEventPresenter < ContentItemPresenter
  def breadcrumbs
    []
  end

  def impact_image
    [content_item.image_for("header"), content_item.image_for("logo"), content_item.image_for("legacy")].find { it }
  end

  def impact_variant
    content_item.notable_death? ? "notable-death" : "plain"
  end
end
