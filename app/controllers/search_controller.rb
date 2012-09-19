class SearchController < ApplicationController
  def index
    @max_results = 50

    @search_term = params[:q]

    if @search_term.blank?
      render action: 'no_search_term' and return
    end

    if @search_term.present?
      begin
        @secondary_results = specialist_results(@search_term, 5)
      rescue GdsApi::Rummager::SearchServiceError
        @secondary_results = []
      end

      remaining_slots = @max_results - @secondary_results.length
      @results = mainstream_results(@search_term, remaining_slots, params["format_filter"])
    end

    if @results.empty? && @secondary_results.empty?
      render action: 'no_results' and return
    end
  end

  protected
  def specialist_results(term, limit = 5)
    res = Frontend.specialist_search_client.search(term, 'specialist_guidance').
      take(limit)
    res.map { |r| OpenStruct.new(r) }
  end

  def mainstream_results(term, limit = 50, format_filter = nil)
    res = Frontend.mainstream_search_client.search(term, format_filter).take(limit)
    res.map { |r| OpenStruct.new(r) }
  end
end
