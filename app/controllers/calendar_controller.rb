class CalendarController < ApplicationController
  before_action :set_cors_headers, if: :json_request?
  before_action :set_locale
  before_action :load_calendar
  before_action :setup_ab_test

  rescue_from Calendar::CalendarNotFound, with: :simple_404

  slimmer_template "gem_layout"

  def calendar
    set_expiry 1.hour

    respond_to do |format|
      format.html do
        @content_item = GdsApi.content_store.content_item("/#{scope}").to_hash
        section_name = @content_item.dig("links", "parent", 0, "links", "parent", 0, "title")
        if section_name
          @meta_section = section_name.downcase
        end

        @faq_presenter = FaqPresenter.new(scope, @calendar, @content_item, view_context)

        render scope.tr("-", "_")
      end
      format.json do
        render json: @calendar
      end
    end
  end

  def division
    handle_bank_holiday_ics_calendars
    division = @calendar.division(params[:division])
    set_expiry 1.day

    respond_to do |format|
      format.json { render json: division }
      format.ics { render plain: IcsRenderer.new(division.events, request.path).render }
      format.all { simple_404 }
    end
  end

private

  def set_cors_headers
    headers["Access-Control-Allow-Origin"] = "*"
  end

  def json_request?
    request.format.symbol == :json
  end

  def scope
    if params[:scope] == "gwyliau-banc"
      "bank-holidays"
    else
      params[:scope]
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def load_calendar
    unless params[:scope].match?(/\A[a-z-]+\z/)
      simple_404
      return
    end
    @calendar = Calendar.find(scope)
  end

  def simple_404
    head 404
  end

  def handle_bank_holiday_ics_calendars
    if scope == "bank-holidays"
      division_slug = Calendar::Division::SLUGS[params[:division]]

      params[:division] = "common.nations.#{division_slug}"
    end
  end

  def setup_ab_test
    ab_test = GovukAbTesting::AbTest.new(
      "AccountBankHols",
      dimension: 46,
      allowed_variants: %w[A B],
      control_variant: "A",
    )
    @requested_variant = ab_test.requested_variant(request.headers)
    @requested_variant.configure_response(response)
  end
end
