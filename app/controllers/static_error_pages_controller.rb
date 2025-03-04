class StaticErrorPagesController < ApplicationController
  ERROR_CODES = %w[
    400
    401
    403
    404
    405
    406
    410
    422
    429
    500
    501
    502
    503
    504
  ].freeze

  def show
    if ERROR_CODES.include?(params[:error_code])
      render action: params[:error_code], layout: false
    else
      head :not_found
    end
  end
end
