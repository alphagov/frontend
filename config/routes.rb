Frontend::Application.routes.draw do
  get "/homepage" => redirect("/")
  get "/search.json" => redirect { |params,req| "/api/search.json?q=#{req.query_parameters['q']}" }
  get "/search" => "search#index", as: :search
  get "/search/opensearch" => "search#opensearch"
  get "/browse.json" => redirect("/api/tags.json?type=section&root_sections=true")
  get "/browse" => "browse#index", to: "browse#index"
  get "/browse/:section.json" => redirect("/api/tags.json?type=section&parent_id=%{section}")
  get "/browse/:section", as: "browse", to: "browse#section"
  get "/browse/:section/:sub_section.json" => redirect("/api/with_tag.json?tag=%{section}%%2F%{sub_section}")
  get "/browse/:section/:sub_section", as: "browse", to: "browse#sub_section"

  # Crude way of handling the situation described at
  # http://stackoverflow.com/a/3443678
  get "*path.gif", to: proc {|env| [404, {}, ["Not Found"]] }

  get "/help/feedback" => redirect("/feedback") # Handled by feedback app
  get "/help/accessibility" => redirect("/support/accessibility")
  get "/help/accessibility-policies" => redirect("/support/accessibility-policies")
  get "/help/cookies" => redirect("/support/cookies")
  get "/help/browsers" => redirect("/support/browsers")
  get "/help/privacy-policy" => redirect("/support/privacy-policy")
  get "/help" => redirect("/support")

  get "/support(/:action)", to: "support"

  get "/tour", to: "root#tour"
  get "/exit", :to => "exit#exit"

  get '/foreign-travel-advice', to: "travel_advice#index", as: :travel_advice
  with_options(:to => "travel_advice#country") do |country|
    country.get "/foreign-travel-advice/:country_slug/print", :format => :print
    country.get "/foreign-travel-advice/:country_slug(/:part)", :as => :travel_advice_country
  end

  # Campaign pages.
  get "/workplacepensions", :to => "campaign#workplace_pensions"
  get "/ukwelcomes", :to => "campaign#uk_welcomes"
  get "/sortmytax", :to => "campaign#sort_my_tax"
  get "/newlicencerules", :to => "campaign#new_licence_rules"
  get "/firekills", :to => "campaign#fire_kills"
  get "/knowbeforeyougo", :to => "campaign#know_before_you_go"
  get "/businesssupport", :to => "campaign#business_support"

  # Temporary redirect that will be replaced with a campaign before long
  get "/unimoney" => redirect("/student-finance", :status => 302)

  # Jobssearch form override (English and Welsh variants)
  constraints(:slug => /(jobsearch|chwilio-am-swydd)/) do
    get "/:slug.json"      => redirect("/api/%{slug}.json")
    get "/:slug(.:format)" => "root#jobsearch"
  end

  get ":slug/y(/*responses)" => "simple_smart_answers#flow", :as => :smart_answer_flow

  with_options(as: "publication", to: "root#publication") do |pub|
    pub.get "*slug", slug: %r{done/.+}
    pub.get ":slug/print", format: :print
    pub.get ":slug/:part/:interaction", as: :licence_authority_action

    # Our approach to providing local transaction information currently
    # requires that this support get and post
    pub.match ":slug(/:part)", :via => [:get, :post]
  end

  root :to => 'root#index', :via => :get
end
