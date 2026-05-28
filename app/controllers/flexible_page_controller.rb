class FlexiblePageController < ContentItemsController
  skip_before_action :allow_only_html_requests

  def show
    respond_to do |format|
      format.html
      format.atom do
        set_expiry(5.minutes)
        headers["Access-Control-Allow-Origin"] = "*"
      end
    end
  end
end
