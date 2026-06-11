class TopicalEventController < FlexiblePageController
  skip_before_action :allow_only_html_requests, only: [:show]

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
