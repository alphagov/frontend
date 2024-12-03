class StaticErrorPagesController < ApplicationController
  after_action do
    response.headers[Slimmer::Headers::SKIP_HEADER] = "true"
  end

  ERROR_CODES = %w[].freeze

  def show
    if ERROR_CODES.include?(params[:error_code])
      render action: params[:error_code], layout: false
    else
      head :not_found
    end
  end
end
