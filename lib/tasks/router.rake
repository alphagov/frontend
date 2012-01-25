namespace :router do
  task :router_environment do
    Bundler.require :router, :default

    require 'logger'
    @logger = Logger.new STDOUT
    @logger.level = Logger::DEBUG

    @router = Router::Client.new :logger => @logger
  end

  task :register_application => :router_environment do
    platform = ENV['FACTER_govuk_platform']
    url = "frontend.#{platform}.alphagov.co.uk/"
    @router.applications.update application_id: "frontend", backend_url: url
  end

  task :register_routes => :router_environment do
    @router.routes.update application_id: "frontend", route_type: :full,
      incoming_path: "/"
    @router.routes.update application_id: "frontend", route_type: :full,
      incoming_path: "/locator.json"
    @router.routes.update application_id: "frontend", route_type: :full,
      incoming_path: "/settings"
    @router.routes.update application_id: "frontend", route_type: :full,
      incoming_path: "/settings.raw"
    @router.routes.update application_id: "frontend", route_type: :prefix,
      incoming_path: "/help"
    @router.routes.update application_id: "frontend", route_type: :full,
      incoming_path: "/feedback"
    @router.routes.update application_id: "frontend", route_type: :prefix,
      incoming_path: "/identify_council"
    @router.routes.update application_id: "frontend", route_type: :prefix,
      incoming_path: "/places"
    @router.routes.update application_id: "frontend", route_type: :full,
      incoming_path: "/google7623855bb2e66cde.html"
    @router.routes.update application_id: "frontend", route_type: :full,
      incoming_path: "/homepage"
  end

  desc "Register frontend application and routes with the router (run this task on server in cluster)"
  task :register => [ :register_application, :register_routes ]
end
