class CalendarController < ApplicationController
  before_action :set_cors_headers, if: :json_request?
  before_action :set_locale
  before_action :load_calendar

  def calendar
    unimplemented!
  end

  def division
    unimplemented!
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

    unimplemented!
  end

  def simple_404
    head 404
  end

  def unimplemented!
    raise "Unimplemented"
  end
end
