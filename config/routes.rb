require 'frontend'

Frontend::Application.routes.draw do
  get "/homepage" => redirect("/")

  get "/search" => "search#index", as: :search
  post "/search" => proc { [405, {}, ["Method Not Allowed"]] } # Prevent non-GET requests for /search blowing up in the publication handlers below
  get "/search/opensearch" => "search#opensearch"

  get "/random" => "random#random_page"

  # Crude way of handling the situation described at
  # http://stackoverflow.com/a/3443678
  get "*path.gif", to: proc { |env| [404, {}, ["Not Found"]] }

  get "/find-local-council" => "find_local_council#index"
  post "/find-local-council" => "find_local_council#find"
  get "/find-local-council/:authority_slug" => "find_local_council#result"

  get '/foreign-travel-advice', to: "travel_advice#index", as: :travel_advice
  post "/foreign-travel-advice" => proc { [405, {}, ["Method Not Allowed"]] } # Prevent POST requests for /foreign-travel-advice blowing up in the publication handlers below
  with_options(to: "travel_advice#country") do |country|
    country.get "/foreign-travel-advice/:country_slug/print", variant: :print, as: :travel_advice_country_print
    country.get "/foreign-travel-advice/:country_slug(/:part)", as: :travel_advice_country
  end

  # Help pages
  get "/help", to: "help#index"
  get "/tour", to: "help#tour"
  get "*slug", slug: %r{help/.+}, to: "help#show", constraints: FormatRoutingConstraint.new('help_page')

  # Done pages
  constraints FormatRoutingConstraint.new('completed_transaction') do
    get "*slug", slug: %r{done/.+}, to: "completed_transaction#show"
  end

  # Simple Smart Answer pages
  get ":slug/y(/*responses)" => "simple_smart_answers#flow", :as => :smart_answer_flow
  constraints FormatRoutingConstraint.new('simple_smart_answer') do
    get ":slug", to: "simple_smart_answers#show"
    get ":slug/:part", to: redirect('/%{slug}') # Support for simple smart answers that were once a format with parts
  end

  # Campaign pages.
  get "/ukwelcomes", to: "campaign#uk_welcomes" # This is a hardcoded page in Frontend and does not have an associated artefact
  constraints FormatRoutingConstraint.new('campaign') do
    get ":slug", to: "campaign#show"
  end

  # Answers pages
  constraints FormatRoutingConstraint.new('answer') do
    get ":slug", to: "answer#show"
    get ":slug/:part", to: redirect('/%{slug}') # Support for answers that were once a format with parts
  end

  # Video pages
  constraints FormatRoutingConstraint.new('video') do
    get ":slug", to: "video#show"
    get ":slug/:part", to: redirect('/%{slug}') # Support for videos that were once a format with parts
  end

  # Guide pages
  constraints FormatRoutingConstraint.new('guide') do
    get ":slug/print", to: "guide#show", variant: :print
    get ":slug(/:part)", to: "guide#show"
  end

  # Programme pages
  constraints FormatRoutingConstraint.new('programme') do
    get ":slug/print", to: "programme#show", variant: :print
    get ":slug(/:part)", to: "programme#show"
  end

  # Transaction pages
  constraints FormatRoutingConstraint.new('transaction') do
    get ":slug", to: "transaction#show"
  end

  # Local Transaction pages
  constraints FormatRoutingConstraint.new('local_transaction') do
    get ":slug", to: "local_transaction#search", as: 'local_transaction_search'
    post ":slug", to: "local_transaction#search"
    get ":slug/:local_authority_slug", to: "local_transaction#results", as: 'local_transaction_results'
  end

  # Business Support pages
  constraints FormatRoutingConstraint.new('business_support') do
    get ":slug", to: "business_support#show"
    get ":slug/:part", to: redirect('/%{slug}') # Support for business support pages that were once a format with parts
  end

  # Place pages
  constraints FormatRoutingConstraint.new('place') do
    get ":slug", to: "place#show"
    post ":slug", to: "place#show" # Support for postcode submission which we treat as confidential data
    get ":slug/:part", to: redirect('/%{slug}') # Support for places that were once a format with parts
  end

  # route API errors to the error handler
  constraints ContentApiErrorRoutingConstraint.new do
    get "*any", to: "error#handler"
  end

  with_options(to: "root#publication") do |pub|
    pub.get ":slug/:part/:interaction", as: :licence_authority_action
    pub.match ":slug(/:part)", via: [:get, :post], as: :publication
  end

  root to: 'homepage#index', via: :get
end
