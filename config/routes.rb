require "frontend"

Rails.application.routes.draw do
  root to: "homepage#index", via: :get

  mount GovukPublishingComponents::Engine, at: "/component-guide"

  get "/homepage" => redirect("/")

  get "/random" => "random#random_page"

  get "/healthcheck", to: proc { [200, {}, %w[OK]] }

  # Crude way of handling the situation described at
  # http://stackoverflow.com/a/3443678
  get "*path.gif", to: proc { |_env| [404, {}, ["Not Found"]] }

  get "/find-local-council" => "find_local_council#index"
  post "/find-local-council" => "find_local_council#find"
  get "/find-local-council/:authority_slug" => "find_local_council#result"

  get "/foreign-travel-advice", to: "travel_advice#index", as: :travel_advice

  # Accounts
  get "/sign-in", to: "sessions#create", as: :new_govuk_session
  get "/sign-in/callback", to: "sessions#callback", as: :new_govuk_session_callback
  get "/sign-out", to: "sessions#delete", as: :end_govuk_session

  # Help pages
  get "/help", to: "help#index"
  get "/help/ab-testing", to: "help#ab_testing"
  get "/tour", to: "help#tour"
  get "/help/cookies", to: "help#cookie_settings"

  # GOVUK Public Roadmap
  get "/roadmap", to: "roadmap#index"

  # Electoral Registration Lookup Service
  get "/find-electoral-things" => "electoral#show"

  # Done pages
  constraints FormatRoutingConstraint.new("completed_transaction") do
    get "*slug", slug: %r{done/.+}, to: "completed_transaction#show"
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

  # Local Transaction pages
  constraints FormatRoutingConstraint.new("local_transaction") do
    get ":slug", to: "local_transaction#search", as: "local_transaction_search"
    post ":slug", to: "local_transaction#search"
    get ":slug/:local_authority_slug", to: "local_transaction#results", as: "local_transaction_results"
  end

  # Place pages
  constraints FormatRoutingConstraint.new("place") do
    get ":slug", to: "place#show"
    post ":slug", to: "place#show" # Support for postcode submission which we treat as confidential data
    get ":slug/:part", to: redirect("/%{slug}") # Support for places that were once a format with parts
  end

  # Licence pages
  constraints FormatRoutingConstraint.new("licence") do
    get ":slug", to: "licence#start", as: "licence"
    post ":slug", to: "licence#start" # Support for postcode submission which we treat as confidential data
    get ":slug/:authority_slug(/:interaction)", to: "licence#authority", as: "licence_authority"
  end

  # Calendar pages
  constraints(format: /(json|ics)/) do
    get "/bank-holidays/ni", to: redirect("/bank-holidays/northern-ireland.%{format}")
  end

  get "/gwyliau-banc", to: "calendar#calendar", defaults: { scope: "gwyliau-banc", locale: :cy }
  get "/gwyliau-banc/:division", to: "calendar#division", defaults: { scope: "gwyliau-banc", locale: :cy }

  constraints FormatRoutingConstraint.new("calendar") do
    get ":scope", to: "calendar#calendar", as: :calendar
    get ":scope/:division", to: "calendar#division", as: :division
  end

  # route API errors to the error handler
  constraints ApiErrorRoutingConstraint.new do
    get "*any", to: "error#handler"
  end
end
