Frontend::Application.routes.draw do
  root :to => "root#index"
  match "/help", :to => "root#help"
  match "/section", :to => "root#section"
  match "/search", :to => "root#search"
  match "/planner", :to => "root#planner"
  match "/plannerresults", :to => "root#plannerresults"
  match "/autocomplete", :to => "root#autocomplete"
  match "/transactions/identify_council/:slug", :as=>"identify_council", :to => "root#identify_council"
  match "/places/load_places/:slug", :as=>"load_places", :to => "root#load_places"
  match ":slug(/:part)",:as=>"publication", :to => "root#publication"
end

