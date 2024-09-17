class CalendarController < ContentItemsController
  include Cacheable
  include BankHolAbTestable

  class InvalidCalendarScope < StandardError; end

  before_action :set_cors_headers, if: :json_request?
  rescue_from Calendar::CalendarNotFound, with: :simple_404
  rescue_from InvalidCalendarScope, with: :simple_404
  prepend_before_action :validate_scope
  skip_before_action :set_expiry, only: [:division]

  def show_calendar
    respond_to do |format|
      format.html do
        @faq_presenter = FaqPresenter.new(calendar.scope, calendar, content_item_hash, view_context)

        render calendar.scope.tr("-", "_")
      end
      format.json do
        set_expiry 1.hour
        render json: calendar
      end
    end
  end

  def division
    handle_bank_holiday_ics_calendars
    div = calendar.division(params[:division])
    set_expiry 1.day

    respond_to do |format|
      format.json { render json: div }
      format.ics { render plain: IcsRenderer.new(div.events, request.path).render }
      format.all { simple_404 }
    end
  end

private

  helper_method :calendar

  def content_item
    @content_item ||= GdsApi.content_store.content_item("/#{params[:scope]}")
  end

  def set_cors_headers
    headers["Access-Control-Allow-Origin"] = "*"
  end

  def json_request?
    request.format.symbol == :json
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def calendar
    @calendar ||= Calendar.find(params[:scope])
  end

  def validate_scope
    raise InvalidCalendarScope unless params[:scope].match?(/\A[a-z-]+\z/)
  end

  def simple_404
    head :not_found
  end

  def handle_bank_holiday_ics_calendars
    if scope == "bank-holidays"
      division_slug = Calendar::Division::SLUGS[params[:division]]

      params[:division] = "common.nations.#{division_slug}"
    end
  end
end
