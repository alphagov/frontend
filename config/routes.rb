require "frontend"

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "homepage#index", via: :get

  mount GovukPublishingComponents::Engine, at: "/component-guide"

  get "/random" => "random#random_page"

  get "/healthcheck/live", to: proc { [200, {}, %w[OK]] }
  get "/healthcheck/ready", to: GovukHealthcheck.rack_response(
    GovukHealthcheck::EmergencyBannerRedis,
  )
  # Crude way of handling the situation described at
  # http://stackoverflow.com/a/3443678
  get "*path.gif", to: proc { |_env| [404, {}, ["Not Found"]] }

  # Favicon redirect
  get "/favicon.ico", to: "favicon#redirect_to_asset"

  unless Rails.env.production?
    get "/development", to: "development#index"
  end

  scope "/api" do
    scope "/local-authority" do
      get "/" => "api/local_authority#index"
      get "/:authority_slug" => "api/local_authority#show"
    end
  end

  get "/find-local-council" => "find_local_council#index"
  post "/find-local-council" => "find_local_council#find"
  get "/find-local-council/multiple_authorities" => "find_local_council#multiple_authorities"
  get "/find-local-council/:authority_slug" => "find_local_council#result"

  get "/foreign-travel-advice", to: "travel_advice#index", as: :travel_advice
  get "/foreign-travel-advice/:country", to: "travel_advice#show"
  get "/foreign-travel-advice/:country/print", to: "travel_advice#show", defaults: { variant: :print }
  get "/foreign-travel-advice/:country/:slug", to: "travel_advice#show"

  scope "/landing-page" do
    get "/", to: "landing_page#show"
    get "/*any", to: "landing_page#show"
  end

  # Accounts
  get "/sign-in", to: "help#sign_in"
  get "/sign-in/redirect", to: "sessions#create"
  get "/sign-in/callback", to: "sessions#callback", as: :new_govuk_session_callback
  get "/sign-out", to: "sessions#delete", as: :end_govuk_session

  scope "/account" do
    get "/", to: "sessions#create", as: :new_govuk_session
    get "/home", to: "account_home#show", as: :account_home
  end

  # Help pages
  scope "/help" do
    get "/:slug", to: "help_page#show", constraints: { slug: /(?!(ab-testing|cookies)$).*/ }
    get "/", to: "help#index", as: :help
    get "/ab-testing", to: "help#ab_testing"
    get "/cookies", to: "help#cookie_settings"
  end

  # GOVUK Public Roadmap
  get "/roadmap", to: "roadmap#index"

  # Electoral Registration Lookup Service
  # comment out this line to return to using a local transaction
  get "/contact-electoral-registration-office" => "electoral#show", as: :electoral_services

  # Specialist Publisher licences
  get "/find-licences/:slug", to: "licence_transaction#start", as: "licence_transaction"
  post "/find-licences/:slug", to: "licence_transaction#find" # Support for postcode submission which we treat as confidential data
  get "/find-licences/:slug/multiple_authorities" => "licence_transaction#multiple_authorities", as: "licence_transaction_multiple_authorities"
  get "/find-licences/:slug/:authority_slug", to: "licence_transaction#authority", as: "licence_transaction_authority"
  get "/find-licences/:slug/:authority_slug/:interaction", to: "licence_transaction#authority_interaction", as: "licence_transaction_authority_interaction"

  # Old style media previews
  get "/media/:id/:filename/preview", to: "csv_preview_redirect#redirect", filename: /[^\/]+/
  # New style CSV previews (using a different path to avoid the special routing for preview_url)
  get "/csv-preview/:id/:filename", to: "csv_preview#show", filename: /[^\/]+/, defaults: { format: "html" }

  scope "/government" do
    # Calls for evidence pages
    get "/calls-for-evidence/:slug(.:locale)", to: "call_for_evidence#show"

    get "/case-studies/:slug(.:locale)", to: "case_study#show", as: :case_study

    get "/collections/:slug", to: "document_collection#show", as: :document_collection

    get "/consultations/:slug(.:locale)", to: "consultation#show"

    get "/fatalities/:slug", to: "fatality_notice#show", as: :fatality_notice

    scope "/fields-of-operation" do
      get "/", to: "fields_of_operation#index"
      get "/:slug", to: "field_of_operation#show"
    end

    get "/get-involved", to: "get_involved#show"

    get "/history", to: "flexible_page#show"
    get "/history/:slug", to: "flexible_page#show"

    get "/how-government-works", to: "how_government_works#show"

    get "/news/:slug(.:locale)", to: "news_article#show"

    get "/organisations/:organisation_slug/about(.:locale)", to: "corporate_information_page#show"
    get "/organisations/:organisation_slug/about/:slug(.:locale)", to: "corporate_information_page#show"

    get "/organisations/hm-passport-office/contact/hm-passport-office-webchat", to: "webchat#show"

    # Placeholder for attachments being virus-scanned
    get "/placeholder", to: "placeholder#show"

    get "/speeches/:slug(.:locale)", to: "speech#show"

    get "/statistical-data-sets/:slug", to: "statistical_data_set#show"

    get "/topical-events/:slug/about", to: "flexible_page#show"
  end

  # Service manuals
  scope "/service-manual" do
    get "/", to: "service_manual#index"
    get "/service-standard", to: "service_manual#service_standard"
    get "/:slug/:document", to: "service_manual#service_manual_guide"
    get "/:topic", to: "service_manual#service_manual_topic"
  end

  # Service toolkit page
  get "/service-toolkit", to: "service_toolkit#index"

  # Static error page routes - in practice used only during deploy, these don't have a
  # published route so can't be accessed from outside
  get "/static-error-pages/:error_code.html", to: "static_error_pages#show"

  # Answer pages
  constraints FormatRoutingConstraint.new("answer") do
    get ":slug", to: "answer#show", as: "answer"
    get ":slug/:part", to: redirect("/%{slug}") # Support for answers that were once a format with parts
  end

  # Calendar pages
  constraints(format: /(json|ics)/) do
    get "/bank-holidays/ni", to: redirect("/bank-holidays/northern-ireland.%{format}")
  end

  constraints FormatRoutingConstraint.new("calendar") do
    get ":slug", to: "calendar#show_calendar", as: :calendar
    get ":slug/:division", to: "calendar#division", as: :division
  end

  constraints FormatRoutingConstraint.new("guide") do
    get ":slug(.:locale)", to: "guide#show"
    get ":slug/print(.:locale)", to: "guide#show", defaults: { variant: :print }
    get ":slug/:part(.:locale)", to: "guide#show"
  end

  # Local Transaction pages
  constraints FormatRoutingConstraint.new("local_transaction") do
    get ":slug", to: "local_transaction#index", as: "local_transaction_search"
    post ":slug", to: "local_transaction#find"
    get ":slug/multiple_authorities" => "local_transaction#multiple_authorities", as: "local_transaction_multiple_authorities"
    get ":slug/:local_authority_slug", to: "local_transaction#results", as: "local_transaction_results"
  end

  # Place pages
  constraints FormatRoutingConstraint.new("place") do
    get ":slug", to: "place#show", as: "place"
    post ":slug", to: "place#find", as: "place_find" # Support for postcode submission which we treat as confidential data
    get ":slug/:part", to: redirect("/%{slug}") # Support for places that were once a format with parts
  end

  # Simple Smart Answer pages
  constraints FormatRoutingConstraint.new("simple_smart_answer") do
    get ":slug/y(/*responses)" => "simple_smart_answers#flow", :as => :smart_answer_flow
    get ":slug", to: "simple_smart_answers#show", as: "simple_smart_answer"
    get ":slug/:part", to: redirect("/%{slug}") # Support for simple smart answers that were once a format with parts
  end

  # Transaction pages
  constraints FormatRoutingConstraint.new("transaction") do
    get ":slug(/:variant)", to: "transaction#show"
  end

  constraints FullPathFormatRoutingConstraint.new("detailed_guide") do
    get "*path(.:locale)", to: "detailed_guide#show"
  end

  constraints FullPathFormatRoutingConstraint.new("flexible_page") do
    get "*path", to: "flexible_page#show"
  end

  constraints FullPathFormatRoutingConstraint.new("html_publication") do
    get "*path(.:locale)", to: "html_publication#show"
  end

  constraints FullPathFormatRoutingConstraint.new("landing_page") do
    get "*path", to: "landing_page#show"
  end

  # Publications - these are all under /government/publications or /government/statistics
  # but they are not the _only_ things in those routes, so we need a full pathformat constraint
  constraints FullPathFormatRoutingConstraint.new("publication") do
    get "*path(.:locale)", to: "publication#show"
  end

  constraints FullPathFormatRoutingConstraint.new("specialist_document") do
    get "*path", to: "specialist_document#show"
  end

  constraints FullPathFormatRoutingConstraint.new("gone") do
    get "*path", to: "gone#show"
  end

  # route API errors to the error handler
  constraints ApiErrorRoutingConstraint.new do
    get "*any", to: "error#handler"
  end
end
