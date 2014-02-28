namespace :router do
  task :router_environment => :environment do
    require 'plek'
    require 'gds_api/router'

    @router_api = GdsApi::Router.new(Plek.current.find('router-api'))
  end

  task :register_backend => :router_environment do
    @router_api.add_backend('frontend', Plek.current.find('frontend', :force_http => true) + "/")
  end

  task :register_routes => :router_environment do
    routes = [
      %w(/ exact),
      %w(/browse prefix),
      %w(/browse.json exact),
      %w(/business exact),
      %w(/search exact),
      %w(/search.json exact),
      %w(/search/opensearch.xml exact),
      %w(/homepage exact),
      %w(/immigration-operational-guidance prefix),
      %w(/oil-and-gas prefix),
      %w(/tour exact),
      %w(/ukwelcomes exact),
      %w(/visas-immigration exact),
    ]

    routes.each do |path, type|
      @router_api.add_route(path, type, 'frontend', :skip_commit => true)
    end
    @router_api.commit_routes
  end

  desc "Register frontend application and routes with the router"
  task :register => [ :register_backend, :register_routes ]
end
