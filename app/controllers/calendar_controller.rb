class CalendarController < ContentItemsController
  include Cacheable
  include BankHolAbTestable

  before_action :set_cors_headers, if: :json_request?
  rescue_from Calendar::CalendarNotFound, with: :simple_404
  skip_before_action :set_expiry, only: [:division]

  def show_calendar
    respond_to do |format|
      format.html do
        @faq_presenter = FaqPresenter.new(calendar.type, calendar, content_item.to_h, view_context)

        render calendar.type.tr("-", "_")
      end
      format.json do
        set_expiry 1.hour
        render json: calendar
      end
    end
  end

  def division
    set_locale
    div = calendar.division(params[:division])
    set_expiry 1.day

    respond_to do |format|
      format.json { render json: div }
      format.ics { render plain: IcsRenderer.new(div.events, request.path, I18n.locale).render }
      format.all { simple_404 }
    end
  end

private

  helper_method :calendar

  def content_item_path
    "/#{params[:slug]}"
  end

  def set_cors_headers
    headers["Access-Control-Allow-Origin"] = "*"
  end

  def json_request?
    request.format.symbol == :json
  end

  def set_locale
    I18n.locale = content_item.locale || I18n.default_locale
  end

  def calendar
    @calendar ||= Calendar.find(params[:slug])
  end

  def simple_404
    head :not_found
  end
end
