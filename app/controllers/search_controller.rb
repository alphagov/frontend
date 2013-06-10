require "slimmer/headers"

class SearchController < ApplicationController

  before_filter :setup_slimmer_artefact, only: [:index]
  before_filter :set_expiry
  helper_method :feature_enabled?, :ministerial_departments, :other_organisations

  rescue_from GdsApi::BaseError, with: :error_503

  def index
    @search_term = params[:q]

    if @search_term.blank?
      render action: 'no_search_term' and return
    else
      @streams = []

      recommended_link_results = grouped_mainstream_results[:recommended_link]

      if feature_enabled?("combine")
        detailed_results = retrieve_detailed_guidance_results(@search_term)
        # hackily downweight detailed results to prevent them swamping mainstream results
        adjusted_detailed_results = detailed_results.map do |detailed_result|
          detailed_result.result["es_score"] = detailed_result.result["es_score"] * 0.8
          detailed_result
        end
        @streams << SearchStream.new(
          "services-information",
          "Services and information",
          merge_result_sets(mainstream_results, adjusted_detailed_results),
          recommended_link_results
        )
        @streams << SearchStream.new(
          "government",
          "Departments and policy",
          retrieve_government_results(@search_term)
        )
      else
        @streams << SearchStream.new(
          "mainstream",
          "General results",
          mainstream_results,
          recommended_link_results
        )
        @streams << SearchStream.new(
          "detailed",
          "Detailed guidance",
          retrieve_detailed_guidance_results(@search_term)
        )
        @streams << SearchStream.new(
          "government",
          "Inside Government",
          retrieve_government_results(@search_term)
        )
      end

      @result_count = @streams.map { |s| s.total_size }.sum
      if feature_enabled?("top_result")
        all_results_ordered = merge_result_sets(*@streams.map(&:results))
        @top_results = all_results_ordered[0..2]
        @top_results.each do |result_to_remove|
          @streams.detect do |stream|
            stream.results.delete(result_to_remove)
          end
        end
      end
    end

    fill_in_slimmer_headers(@result_count)

    @active_stream = active_stream(@streams)

    # We want to show the tabs if there's a filter in place
    # because there might be results with the filter turned off, but you can't
    # do that if the filter-form/tabs aren't displayed
    if (@result_count == 0) && params[:organisation].blank?
      render action: 'no_results' and return
    end
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
    res = Frontend.mainstream_search_client.search(term, extra_search_parameters)
    res["results"].map { |r| SearchResult.new(r) }
  end

  def retrieve_detailed_guidance_results(term)
    res = Frontend.detailed_guidance_search_client.search(term, extra_search_parameters)
    res["results"].map { |r| SearchResult.new(r) }
  end

  def retrieve_government_results(term)
    extra_parameters = extra_search_parameters
    extra_parameters[:organisation_slug] = params[:organisation] if params[:organisation]
    res = Frontend.government_search_client.search(term, extra_parameters)
    res["results"].map { |r| GovernmentResult.new(r) }
  end

  def extra_search_parameters
    extra_parameters = { response_style: "hash" }
    extra_parameters[:minimum_should_match] = "1" if feature_enabled?(:minimum_should_match)
    extra_parameters
  end

  def merge_result_sets(*result_sets)
    # .sort_by(&:es_score) will return it back to front
    result_sets.flatten(1).sort_by(&:es_score).reverse
  end

  def fill_in_slimmer_headers(result_count)
    set_slimmer_headers(
      result_count: result_count,
      format:       "search",
      section:      "search",
      proposition:  "citizen"
    )
  end

  def setup_slimmer_artefact
    set_slimmer_dummy_artefact(:section_name => "Search", :section_link => "/search")
  end

  def selected_tab
    tabs =  %w{ government-results detailed-results mainstream-results }
    tabs.include?(params[:tab]) ? params[:tab] : nil
  end

  def active_stream(streams)
    active_stream = streams.detect do |stream|
      stream_key_as_tab_name = "#{stream.key}-results"
      if selected_tab
        stream_key_as_tab_name == selected_tab
      else
        stream.anything_to_show?
      end
    end
    active_stream || streams.first
  end

  def feature_enabled?(feature_name)
    if params[feature_name].present?
      params[feature_name] =~ /^1|true|yes/
    else
      PROTOTYPE_FEATURES_ENABLED_BY_DEFAULT
    end
  end

  def organisations
    @_organisations ||= Frontend.organisations_search_client.organisations["results"] || []
  end

  MINISTERIAL_DEPARTMENT_TYPE = "Ministerial department"
  def ministerial_departments
    organisations.select do |organisation|
      organisation["organisation_type"] == MINISTERIAL_DEPARTMENT_TYPE
    end.sort_by { |organisation| organisation["title"] }
  end

  def other_organisations
    organisations.reject do |organisation|
      organisation["organisation_type"] == MINISTERIAL_DEPARTMENT_TYPE
    end.sort_by { |organisation| organisation["title"] }
  end
end
