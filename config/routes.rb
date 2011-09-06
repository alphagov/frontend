Frontend::Application.routes.draw do
  root :to => "root#index"
  match "/help", :to => "root#help"
  match ":slug(/:part)", :to => "root#publication"
end

