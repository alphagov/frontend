require 'frontend'

Frontend::Application.routes.draw do
  get "/homepage" => redirect("/")
  get "/search" => "search#unified", as: :unified_search, constraints: lambda { |req| req.query_parameters['ui'] == 'unified'}
  get "/search.json" => redirect { |params,req| "/api/search.json?q=#{CGI.escape(req.query_parameters['q'] || '')}" }
  get "/search" => "search#index", as: :search
  post "/search" => proc { [405, {}, ["Method Not Allowed"]] } # Prevent non-GET requests for /search blowing up in the publication handlers below
  get "/search/opensearch" => "search#opensearch"

  # Redirects for visas-immigration section changes.
  # TODO: Move these into the router
  get '/browse/visas-immigration/visit-visas' => redirect('/browse/visas-immigration/short-visit-visas')
  get '/browse/visas-immigration/working-visas' => redirect('/browse/visas-immigration/work-visas')
  get '/browse/visas-immigration/employers-sponsorship' => redirect('/browse/visas-immigration/sponsoring-workers-students')
  get '/browse/visas-immigration/your-visa' => redirect('/browse/visas-immigration/after-youve-applied')
  get '/browse/visas-immigration/family-visas' => redirect('/browse/visas-immigration')

  get "/browse.json" => redirect("/api/tags.json?type=section&root_sections=true")
  get "/browse" => "browse#index", to: "browse#index"
  get "/browse/:section.json" => redirect("/api/tags.json?type=section&parent_id=%{section}")
  get "/browse/:section", as: "browse", to: "browse#section"
  get "/browse/:section/:sub_section.json" => redirect("/api/with_tag.json?tag=%{section}%%2F%{sub_section}")
  get "/browse/:section/:sub_section", as: "browse", to: "browse#sub_section"

  # new-style browse pages
  get "/business" => "browse#section", :section => "business"
  get "/visas-immigration" => "browse#section", :section => "visas-immigration"

  constraints(proc {|req| Frontend.specialist_sectors.include?(req.params[:sector]) }) do
    get "/:sector" => "specialist_sectors#sector"
    get "/:sector(/:subcategory)" => "specialist_sectors#subcategory"
  end

  # Crude way of handling the situation described at
  # http://stackoverflow.com/a/3443678
  get "*path.gif", to: proc {|env| [404, {}, ["Not Found"]] }

  get "/help", to: "help#index"
  get "/tour", to: "root#tour"

  get '/foreign-travel-advice', to: "travel_advice#index", as: :travel_advice
  post "/foreign-travel-advice" => proc { [405, {}, ["Method Not Allowed"]] } # Prevent POST requests for /foreign-travel-advice blowing up in the publication handlers below
  with_options(:to => "travel_advice#country") do |country|
    country.get "/foreign-travel-advice/:country_slug/print", :format => :print
    country.get "/foreign-travel-advice/:country_slug(/:part)", :as => :travel_advice_country
  end

  # Campaign pages.
  with_options :format => false do |routes|
    routes.get "/ukwelcomes", :to => "campaign#uk_welcomes"
  end

  # Jobssearch form override (English and Welsh variants)
  constraints(:slug => /(jobsearch|chwilio-am-swydd)/) do
    get "/:slug.json"      => redirect("/api/%{slug}.json")
    get "/:slug(.:format)" => "root#jobsearch"
  end

  # Transaction finished pages
  constraints(slug: /(transaction-finished|driving-transaction-finished)/) do
    get "/:slug.json"      => redirect("/api/%{slug}.json")
    get "/:slug(.:format)" => "root#legacy_completed_transaction"
  end

  get ":slug/y(/*responses)" => "simple_smart_answers#flow", :as => :smart_answer_flow

  with_options(as: "publication", to: "root#publication") do |pub|
    pub.get "*slug", slug: %r{(done|help)/.+}
    pub.get ":slug/print", format: :print
    pub.get ":slug/:part/:interaction", as: :licence_authority_action

    # Our approach to providing local transaction information currently
    # requires that this support get and post
    pub.match ":slug(/:part)", :via => [:get, :post]
  end

  root :to => 'root#index', :via => :get
end
