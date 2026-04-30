module Api
  class AutocompletesController < ApplicationController
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
  end
end
