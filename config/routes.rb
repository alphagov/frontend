Frontend::Application.routes.draw do
  match "/homepage" => redirect("/")
  match "/search" => "search#index", as: :search
  match "/browse" => "browse#index", to: "browse#index"
  match "/browse/:section", as: "browse", to: "browse#section"
  match "/browse/:section/:sub_section", as: "browse", to: "browse#sub_section"

  # Crude way of handling the situation described at
  # http://stackoverflow.com/a/3443678
  match "*path.gif", to: proc {|env| [404, {}, ["Not Found"]] }

  match "/help/feedback" => redirect("/feedback") # Handled by feedback app
  match "/help(/:action)", to: "help"

  match "/settings", to: "root#settings"
  match "/tour", to: "root#tour"
  match "/exit", :to => "exit#exit"

  # Campaign pages.
  match "/workplacepensions", :to => "campaign#workplace_pensions"

  with_options(as: "publication", to: "root#publication") do |pub|
    pub.match ":slug/video", format: :video
    pub.match ":slug/print", format: :print
    pub.match ":slug/:part/:interaction", as: :licence_authority_action
    pub.match ":slug(/:part)"
  end

  root :to => 'root#index'
end
