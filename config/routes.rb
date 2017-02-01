require 'frontend'

Frontend::Application.routes.draw do
  get "/homepage" => redirect("/")

  get "/search" => "search#index", as: :search
  get "/search/opensearch" => "search#opensearch"

  get "/random" => "random#random_page"

  # Crude way of handling the situation described at
  # http://stackoverflow.com/a/3443678
  get "*path.gif", to: proc { |env| [404, {}, ["Not Found"]] }

  get "/find-local-council" => "find_local_council#index"
  post "/find-local-council" => "find_local_council#find"
  get "/find-local-council/:authority_slug" => "find_local_council#result"

  get '/foreign-travel-advice', to: "travel_advice#index", as: :travel_advice

  # Help pages
  get "/help", to: "help#index"
  get "/help/ab-testing", to: "help#ab_testing"
  get "/tour", to: "help#tour"
  constraints FormatRoutingConstraint.new('help_page') do
    get "*slug.json", slug: %r{help/.+}, to: "help#show", format: 'json'
    get "*slug", slug: %r{help/.+}, to: "help#show"
  end

  # Done pages
  constraints FormatRoutingConstraint.new('completed_transaction') do
    get "*slug", slug: %r{done/.+}, to: "completed_transaction#show"
  end

  # Simple Smart Answer pages
  get ":slug/y(/*responses)" => "simple_smart_answers#flow", :as => :smart_answer_flow
  constraints FormatRoutingConstraint.new('simple_smart_answer') do
    get ":slug", to: "simple_smart_answers#show", as: "simple_smart_answer"
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
    get ":slug(/:part)", to: "guide#show", as: "guide"
  end

  # Programme pages
  constraints FormatRoutingConstraint.new('programme') do
    get ":slug/print", to: "programme#show", variant: :print
    get ":slug(/:part)", to: "programme#show", as: "programme"
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

  # Licence pages
  constraints FormatRoutingConstraint.new('licence') do
    get ":slug", to: "licence#search", as: "licence"
    post ":slug", to: "licence#search" # Support for postcode submission which we treat as confidential data
    get ":slug/:authority_slug(/:interaction)", to: "licence#authority", as: "licence_authority"
  end

  # route API errors to the error handler
  constraints ContentApiErrorRoutingConstraint.new do
    get "*any", to: "error#handler"
  end

  root to: 'homepage#index', via: :get
end
