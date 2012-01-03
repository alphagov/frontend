Frontend::Application.routes.draw do
  match "/homepage", :to => "root#index"
  match "/help(/:action)", :to => "help"
  match "/error_500", :to => "root#error_500"
  match "/error_501", :to => "root#error_501"
  match "/error_503", :to => "root#error_503"
  match "/platform(/:slug)", :to => "platform#index"
  match "/section", :to => "root#section"
  match "/identify_council/:slug", :as => "identify_council", :to => "root#identify_council"
  match "/places/load_places/:slug", :as => "load_places", :to => "root#load_places"
  
  with_options(:as => "publication", :to => "root#publication") do |pub|
    pub.match ":slug/video", :format => :video
    pub.match ":slug/print", :format => :print
    pub.match ":slug(/:part)"
  end
end
  
