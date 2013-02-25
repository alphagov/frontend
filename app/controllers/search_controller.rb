require "slimmer/headers"

class SearchController < ApplicationController

  before_filter :setup_slimmer_artefact, only: [:index]
  before_filter :set_expiry
  before_filter :set_results_tab, only: [:index]

  def index
    @search_term = params[:q]

    if @search_term.blank?
      render action: 'no_search_term' and return
    end

    @display_score = false
    if Rails.env.development?
      @display_score = true
    end

    if @search_term.present?
      @mainstream_results = mainstream_results
      @recommended_link_results = grouped_mainstream_results[:recommended_link]
      @detailed_guidance_results = retrieve_detailed_guidance_results(@search_term)
      @government_results = retrieve_government_results(@search_term)

      @all_results = @mainstream_results + @detailed_guidance_results + @government_results + @recommended_link_results
      @count_results = @mainstream_results + @detailed_guidance_results + @government_results
    end

    fill_in_slimmer_headers(@all_results)

    if @all_results.empty?
      render action: 'no_results' and return
    end
  rescue GdsApi::Rummager::SearchServiceError
    error_503 and return
  end

  protected

  def grouped_mainstream_results
    @_grouped_mainstream_results ||= begin
      results = retrieve_mainstream_results(@search_term)
      grouped_results = results.group_by do |result|
        if !result.respond_to?(:format)
          :everything_else
        else
          if result.format == 'recommended-link'
            :recommended_link
          elsif result.format == 'inside-government-link'
            :inside_government_link
          else
            :everything_else
          end
        end
      end
      grouped_results[:recommended_link] ||= []
      grouped_results[:inside_government_link] ||= []
      grouped_results[:everything_else] ||= []
      grouped_results
    end
  end

  def mainstream_results
    @mainstream_results = grouped_mainstream_results[:inside_government_link] + grouped_mainstream_results[:everything_else]
  end

  def retrieve_mainstream_results(term)
    res = Frontend.mainstream_search_client.search(term)
    res.map { |r| SearchResult.new(r) }
  end

  def retrieve_detailed_guidance_results(term)
    res = Frontend.detailed_guidance_search_client.search(term)
    res.map { |r| SearchResult.new(r) }
  end

  def retrieve_government_results(term)
    res = Frontend.government_search_client.search(term)
    res.map { |r| GovernmentResult.new(r) }
  end

  def fill_in_slimmer_headers(result_set)
    set_slimmer_headers(
      result_count: result_set.length,
      format:       "search",
      section:      "search",
      proposition:  "citizen"
    )
  end

  def setup_slimmer_artefact
    set_slimmer_dummy_artefact(:section_name => "Search", :section_link => "/search")
  end

  def set_results_tab
    tabs =  %w{ government-results detailed-results mainstream-results }
    @results_tab = tabs.include?(params[:tab]) ? params[:tab] : nil
  end
end
