class SearchParameters
  include Rails.application.routes.url_helpers

  attr_reader :start, :count

  DEFAULT_RESULTS_PER_PAGE = 50
  MAX_RESULTS_PER_PAGE = 100

  def initialize(params)
    @params = enforce_bounds(params)
  end

  def search_term
    params[:q]
  end

  def start
    params[:start]
  end

  def count
    params[:count]
  end

  def no_search?
    search_term.blank?
  end

  def filter(field)
    [*(params["filter_#{field}"] || [])]
  end

  def debug_score
    params[:debug_score]
  end

  # Build a link to a search results page.
  def build_link(extra = {})
    search_path(combine_params(extra))
  end

  def rummager_parameters
    {
      start: start.to_s,
      count: count.to_s,
      q: search_term,
      filter_organisations: filter(:organisations),
      facet_organisations: "100",
      fields: %w{
        description
        display_type
        document_series
        format
        last_update
        link
        organisations
        organisation_state
        public_timestamp
        section
        slug
        specialist_sectors
        subsection
        subsubsection
        title
        topics
        world_locations
      },
      debug: params[:debug],
    }
  end

private

  attr_reader :params

  def enforce_bounds(params)
    params.merge(
      start: check_start(params),
      count: check_count(params),
    )
  end

  def check_start(params)
    start = (params[:start] || 0).to_i
    if start < 0
      0
    else
      start
    end
  end

  def check_count(params)
    count = (params[:count] || 0).to_i
    if count <= 0
      DEFAULT_RESULTS_PER_PAGE
    elsif count > MAX_RESULTS_PER_PAGE
      MAX_RESULTS_PER_PAGE
    else
      count
    end
  end

  def combine_params(extra)
    # explicitly set the format to nil so that the path does not point to
    # /search.json
    combined_params = params.merge(format: nil).merge(extra)

    # don't include the 'count' query parameter unless we are overriding the
    # default value with a custom value
    unless custom_count_value?(combined_params[:count])
      combined_params.delete(:count)
    end
    combined_params
  end

  def custom_count_value?(count)
    count != 0 &&
      count != DEFAULT_RESULTS_PER_PAGE
  end
end
