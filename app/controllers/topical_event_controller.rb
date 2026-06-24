class TopicalEventController < FlexiblePageController
  attr_reader :content_presenter

  helper_method :content_presenter

  def show
    @content_presenter = TopicalEventPresenter.new(content_item)

    respond_to do |format|
      format.html
      format.atom do
        set_expiry(5.minutes)
        headers["Access-Control-Allow-Origin"] = "*"
      end
    end
  end

  def about
    @content_presenter = TopicalEventAboutPagePresenter.new(content_item)
  end
end
