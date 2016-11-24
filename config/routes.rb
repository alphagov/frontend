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

  # Campaign pages.
  get "/ukwelcomes", to: "campaign#uk_welcomes" # This is a special case.
  get ":slug", to: "campaign#show", constraints: FormatRoutingConstraint.new('campaign')

  # Transaction finished pages
  constraints(slug: /(transaction-finished|driving-transaction-finished)/) do
    get "/:slug.json"      => redirect("/api/%{slug}.json")
    get "/:slug(.:format)" => "root#legacy_completed_transaction"
  end

  # Simple Smart Answer pages
  get ":slug/y(/*responses)" => "simple_smart_answers#flow", :as => :smart_answer_flow
  get ":slug", to: "simple_smart_answers#show", constraints: FormatRoutingConstraint.new('simple_smart_answer')

  # Help pages
  get "/help", to: "help#index"
  get "/tour", to: "help#tour"
  get "*slug", slug: %r{help/.+}, to: "help#show", constraints: FormatRoutingConstraint.new('help_page')

  # Answers pages
  get ":slug", to: "answer#show", constraints: FormatRoutingConstraint.new('answer')

  # Video pages
  get ":slug", to: "video#show", constraints: FormatRoutingConstraint.new('video')

  # Done pages
  get "*slug", slug: %r{done/.+}, to: "root#publication"

  # Guide pages
  get ":slug/print", to: "guide#show", variant: :print, constraints: FormatRoutingConstraint.new('guide')
  get ":slug(/:part)", to: "guide#show", constraints: FormatRoutingConstraint.new('guide')

  # Programme pages
  get ":slug/print", to: "programme#show", variant: :print, constraints: FormatRoutingConstraint.new('programme')
  get ":slug(/:part)", to: "programme#show", constraints: FormatRoutingConstraint.new('programme')

  # Transaction pages
  get ":slug", to: "transaction#show", constraints: FormatRoutingConstraint.new('transaction')

  with_options(to: "root#publication") do |pub|
    pub.get ":slug/:part/:interaction", as: :licence_authority_action

    # Our approach to providing local transaction information currently
    # requires that this support get and post
    pub.match ":slug(/:part)", via: [:get, :post], as: :publication
  end

  root to: 'homepage#index', via: :get
end
