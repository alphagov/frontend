require "frontend"

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "homepage#index", via: :get

  mount GovukPublishingComponents::Engine, at: "/component-guide"

  get "/random" => "random#random_page"

  get "/healthcheck/live", to: proc { [200, {}, %w[OK]] }
  get "/healthcheck/ready", to: GovukHealthcheck.rack_response

  # Crude way of handling the situation described at
  # http://stackoverflow.com/a/3443678
  get "*path.gif", to: proc { |_env| [404, {}, ["Not Found"]] }

  unless Rails.env.production?
    get "/development", to: "development#index"
  end

  get "/find-local-council" => "find_local_council#index"
  post "/find-local-council" => "find_local_council#find"
  get "/find-local-council/multiple_authorities" => "find_local_council#multiple_authorities"
  get "/find-local-council/:authority_slug" => "find_local_council#result"

  get "/foreign-travel-advice", to: "travel_advice#index", as: :travel_advice

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
  get "/help", to: "help#index"
  get "/help/ab-testing", to: "help#ab_testing"
  get "/help/cookies", to: "help#cookie_settings"

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

  # Calendar pages
  constraints(format: /(json|ics)/) do
    get "/bank-holidays/ni", to: redirect("/bank-holidays/northern-ireland.%{format}")
  end

  get "/gwyliau-banc", to: "calendar#show_calendar", defaults: { scope: "gwyliau-banc", locale: :cy }
  get "/gwyliau-banc/:division", to: "calendar#division", defaults: { scope: "gwyliau-banc", locale: :cy }

  constraints FormatRoutingConstraint.new("calendar") do
    get ":scope", to: "calendar#show_calendar", as: :calendar
    get ":scope/:division", to: "calendar#division", as: :division
  end

  get "/government/uploads/system/uploads/attachment_data/file/:id/:filename.csv/preview", to: "csv_preview#show", filename: /[^\/]+/, legacy: true
  get "/media/:id/:filename/preview", to: "csv_preview#show", filename: /[^\/]+/

  get "/government/placeholder", to: "placeholder#show"

  # route API errors to the error handler
  constraints ApiErrorRoutingConstraint.new do
    get "*any", to: "error#handler"
  end
end
