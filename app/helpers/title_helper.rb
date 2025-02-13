module TitleHelper
  def withdrawable_title(content_item)
    content_item.withdrawn? ? "[Withdrawn] #{content_item.title}" : content_item.title
  end
end
