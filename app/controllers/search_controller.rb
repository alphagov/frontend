class SearchController < ApplicationController
  def index
    @top_results = 4
    @max_more_results = 46
    @max_recommended_results = 2

    @search_term = params[:q]
    if @search_term.present?
      @results = rummager_client.search(@search_term)
    end

    respond_to do |format|
      format.html { 
        if @search_term.blank?
          render action: 'no_search_term'
        elsif @results.empty?
          render action: 'no_results'
        else
          render
        end
      }
      format.json { render json: @results }
    end
  end

  protected
  def rummager_client
    @rummager_client ||= GdsApi::Rummager.new(Plek.current.find('search'))
  end
end
