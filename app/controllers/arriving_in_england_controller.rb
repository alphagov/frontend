class ArrivingInEnglandController < ApplicationController
  def from
    @world_locations = world_locations
  end

  def other_countries
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
end
