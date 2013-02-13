Frontend::Application.routes.draw do
  match "/homepage" => redirect("/")
  match "/search" => "search#index", as: :search
  match "/search/opensearch" => "search#opensearch"
  match "/browse" => "browse#index", to: "browse#index"
  match "/browse/:section", as: "browse", to: "browse#section"
  match "/browse/:section/:sub_section", as: "browse", to: "browse#sub_section"

  # Crude way of handling the situation described at
  # http://stackoverflow.com/a/3443678
  match "*path.gif", to: proc {|env| [404, {}, ["Not Found"]] }

  match "/help/feedback" => redirect("/feedback") # Handled by feedback app
  match "/help/accessibility" => redirect("/support/accessibility")
  match "/help/accessibility-policies" => redirect("/support/accessibility-policies")
  match "/help/cookies" => redirect("/support/cookies")
  match "/help/privacy-policy" => redirect("/support/privacy-policy")
  match "/help" => redirect("/support")

  match "/support(/:action)", to: "support"

  match "/tour", to: "root#tour"
  match "/exit", :to => "exit#exit"

  match '/travel-advice', to: "travel_advice#index", as: :travel_advice_country
  with_options(:to => "travel_advice#country") do |country|
    country.match "/travel-advice/:country_slug/print", :format => :print
    country.match "/travel-advice/:country_slug(/:part)", :as => :travel_advice_country
  end

  # Campaign pages.
  match "/workplacepensions", :to => "campaign#workplace_pensions"
  match "/ukwelcomes", :to => "campaign#uk_welcomes"
  match "/sortmytax", :to => "campaign#sort_my_tax"
  match "/newlicencerules", :to => "campaign#new_licence_rules"

  # Jobssearch form override (English and Welsh variants)
  match "/:slug" => "root#jobsearch", :constraints => {:slug => /(jobsearch|chwilio-am-swydd)/}

  with_options(as: "publication", to: "root#publication") do |pub|
    pub.match ":slug/video", format: :video
    pub.match ":slug/print", format: :print
    pub.match ":slug/:part/:interaction", as: :licence_authority_action
    pub.match ":slug(/:part)"
  end

  root :to => 'root#index'
end
