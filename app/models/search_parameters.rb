class SearchParameters
  include Rails.application.routes.url_helpers

  attr_reader :start, :count

  DEFAULT_RESULTS_PER_PAGE = 20
  MAX_RESULTS_PER_PAGE = 100
  ALWAYS_FACET_FIELDS = %w{organisations}
  ALLOWED_FACET_FIELDS = %w{organisations topics manual}

  # specialist_sectors will be renamed to topics at some point.  To avoid
  # people ever seeing the old name, we map it here, and back again in the presenter.
  EXTERNAL_TO_INTERNAL_FIELDS = {
    "topics" => "specialist_sectors",
  }
  INTERNAL_TO_EXTERNAL_FIELDS = {
    "specialist_sectors" => "topics",
  }

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

  def filtered_by?(field)
    ! filter(field).empty?
  end

  def debug_score
    params[:debug_score]
  end

  # Build a link to a search results page.
  def build_link(extra = {})
    search_path(combine_params(extra))
  end

  def rummager_parameters
    result = {
      start: start.to_s,
      count: count.to_s,
      q: search_term,
      fields: %w{
        description
        display_type
        document_series
        format
        government_name
        is_historic
        link
        organisations
        organisation_state
        public_timestamp
        slug
        specialist_sectors
        title
        world_locations
      },
      debug: params[:debug],
    }
    active_facet_fields.each { |field|
      internal = SearchParameters::internal_field_name(field)
      result["filter_#{internal}".to_sym] = filter(field)
      result["facet_#{internal}".to_sym] = "100"
    }
    result
  end

  def active_facet_fields
    ALLOWED_FACET_FIELDS.select { |field|
      ALWAYS_FACET_FIELDS.include?(field) || filtered_by?(field)
    }
  end

  def self.external_field_name(field)
    INTERNAL_TO_EXTERNAL_FIELDS.fetch(field, field)
  end

  def self.internal_field_name(field)
    EXTERNAL_TO_INTERNAL_FIELDS.fetch(field, field)
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

    # don't include the start parameter if it's zero
    if combined_params[:start] == 0
      combined_params.delete(:start)
    end

    combined_params
  end

  def custom_count_value?(count)
    count != 0 &&
      count != DEFAULT_RESULTS_PER_PAGE
  end
end
