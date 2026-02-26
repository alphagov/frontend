class FlexiblePageController < ContentItemsController
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
