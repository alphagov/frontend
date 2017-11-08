class SearchController < ApplicationController
  before_action :set_expiry
  before_action :remove_search_box

  rescue_from GdsApi::BaseError, with: :error_503

  def index
    search_params = SearchParameters.new(permitted_search_params.to_h)

    setup_content_item("/search")

    if search_params.no_search? && permitted_search_params[:format] != "json"
      render action: 'no_search_term' and return
    end
    search_response = SearchAPI.new(search_params).search

    @search_term = search_params.search_term

    if (search_response["scope"].present?)
      @results = ScopedSearchResultsPresenter.new(search_response, search_params)
    else
      @results = SearchResultsPresenter.new(search_response, search_params)
    end

    @facets = search_response["facets"]
    @spelling_suggestion = @results.spelling_suggestion

    fill_in_slimmer_headers(@results.result_count)

    respond_to do |format|
      format.html { render locals: { full_width: true } }
      format.json { render json: @results }
    end
  end

protected

  def remove_search_box
    set_slimmer_headers(remove_search: true)
  end

  def fill_in_slimmer_headers(result_count)
    set_slimmer_headers(
      result_count: result_count,
      section:      "search",
    )
  end

private

  def permitted_search_params
    params.permit(:q, :filter_manual, { filter_organisations: [] }, :show_organisations_filter, :format, :count, :start)
  end
end
