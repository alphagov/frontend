class TopicalEventController < FlexiblePageController
  def show
    respond_to do |format|
      format.html do
        render "flexible_page/show"
      end
      format.atom do
        set_expiry(5.minutes)
        headers["Access-Control-Allow-Origin"] = "*"
      end
    end
  end

  def about
    render "flexible_page/show"
  end
end
