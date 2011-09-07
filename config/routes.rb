Frontend::Application.routes.draw do
  root :to => "root#index"
  match "/help", :to => "root#help"
  match "/section", :to => "root#section"
  match "/search", :to => "root#search"
  match "/transactions/identify_council/:slug", :as=>"identify_council", :to => "root#identify_council"
  match ":slug(/:part)",:as=>"publication", :to => "root#publication"
end

