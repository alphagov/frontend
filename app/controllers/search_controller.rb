class SearchController < ApplicationController
  before_filter :set_expiry
  before_filter :remove_search_box
  helper_method :search_ab_test_variant
  after_filter :set_search_ab_test_response_header

  rescue_from GdsApi::BaseError, with: :error_503

  SEARCH_FORMAT_BOOSTING_DIMENSION = 42

  def index
    search_params = SearchParameters.new(params)

    setup_content_item("/search")

    if search_params.no_search? && params[:format] != "json"
      render action: 'no_search_term' and return
    end
    variant = search_ab_test_variant.variant_name
    search_response = SearchAPI.new(search_params, format_boosting: variant).search

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

  def search_ab_test
    GovukAbTesting::AbTest.new(
      "SearchFormatBoosting",
      dimension: SEARCH_FORMAT_BOOSTING_DIMENSION
    )
  end

  def search_ab_test_variant
    @_search_ab_test_variant ||=
      search_ab_test.requested_variant(request.headers)
  end

  def set_search_ab_test_response_header
    search_ab_test_variant.configure_response(response)
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
end
