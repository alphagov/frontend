module Api
  class AutocompletesController < ApplicationController
    rescue_from ActionController::ParameterMissing, with: :bad_request

    def index
      render json: autocomplete_response
    end

  private

    def autocomplete_response
      Services
        .search_api_v2
        .autocomplete(params.require(:q))
        .to_hash
    end

    def bad_request
      render status: :bad_request, plain: "400 error: bad request"
    end
  end
end
