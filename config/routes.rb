Frontend::Application.routes.draw do
  root :to => "root#index"
  match "/help", :to => "root#help"
  match "/section", :to => "root#section"
  match "/search", :to => "root#search"
  match "/search-promoted", :to => "root#search_promoted"
  match "/search-not-found", :to => "root#search_not_found"
  match "/smartanswer", :to => "root#smartanswer"
  match "/autocomplete", :to => "root#autocomplete"
  match "/transactions/identify_council/:slug", :as=>"identify_council", :to => "root#identify_council"
  match "/places/load_places/:slug", :as=>"load_places", :to => "root#load_places"
  match ":slug(/:part)",:as=>"publication", :to => "root#publication"
end

