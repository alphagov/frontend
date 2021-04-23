class ArrivingInEnglandController < ApplicationController
  def from
    @world_locations = world_locations
  end

  def other_countries
    if params[:any_other] == "no"
      redirect_to arriving_in_england_results_path(countries: [params[:country]])
      return
    end

    @countries = params.fetch(:countries, [params[:country]]).uniq

    @world_locations = world_locations
  end

  def world_locations
    GdsApi.worldwide
          .world_locations
          .with_subsequent_pages
          .each_with_object({}) do |location, memo|
            memo[location.dig("details", "slug")] = location["title"]
          end
  end

  def results
    @countries = params.fetch(:countries, [params[:country]]).uniq

    @world_locations = world_locations
    @rag_statuses = YAML.load_file(Rails.root.join("config/arriving_in_england.yml"))
  end
end
