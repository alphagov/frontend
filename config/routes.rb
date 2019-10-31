require "frontend"

Rails.application.routes.draw do
  root to: "homepage#index", via: :get

  get "/homepage" => redirect("/")

  get "/random" => "random#random_page"

  # Crude way of handling the situation described at
  # http://stackoverflow.com/a/3443678
  get "*path.gif", to: proc { |env| [404, {}, ["Not Found"]] }

  get "/find-local-council" => "find_local_council#index"
  post "/find-local-council" => "find_local_council#find"
  get "/find-local-council/:authority_slug" => "find_local_council#result"

  get "/foreign-travel-advice", to: "travel_advice#index", as: :travel_advice

  # Help pages
  get "/help", to: "help#index"
  get "/help/ab-testing", to: "help#ab_testing"
  get "/tour", to: "help#tour"
  get "/help/cookies", to: "help#cookie_settings"

  # Funding Form pages
  get "/brexit-eu-funding" => "funding_form#index", as: "funding_form"
  get "/brexit-eu-funding/who-should-we-contact-about-the-grant-award" => "funding_form/contact_information#show", as: "contact_information"
  post "/brexit-eu-funding/who-should-we-contact-about-the-grant-award" => "funding_form/contact_information#submit"
  get "/brexit-eu-funding/organisation-type" => "funding_form/organisation_type#show", as: "organisation_type"
  post "/brexit-eu-funding/organisation-type" => "funding_form/organisation_type#submit"
  get "/brexit-eu-funding/organisation-details" => "funding_form/organisation_details#show", as: "organisation_details"
  post "/brexit-eu-funding/organisation-details" => "funding_form/organisation_details#submit"
  get "/brexit-eu-funding/do-you-have-a-companies-house-or-charity-commission-number" => "funding_form/companies_house_number#show", as: "companies_house_number"
  post "/brexit-eu-funding/do-you-have-a-companies-house-or-charity-commission-number" => "funding_form/companies_house_number#submit"
  get "/brexit-eu-funding/do-you-have-a-grant-agreement-number" => "funding_form/grant_agreement_number#show", as: "grant_agreement_number"
  post "/brexit-eu-funding/do-you-have-a-grant-agreement-number" => "funding_form/grant_agreement_number#submit"
  get "/brexit-eu-funding/what-programme-do-you-receive-funding-from" => "funding_form/programme#show", as: "programme"
  post "/brexit-eu-funding/what-programme-do-you-receive-funding-from" => "funding_form/programme#submit"
  get "/brexit-eu-funding/project-details" => "funding_form/project_details#show", as: "project_details"
  post "/brexit-eu-funding/project-details" => "funding_form/project_details#submit"
  get "/brexit-eu-funding/does-the-project-have-partners-or-participants-outside-the-uk" => "funding_form/partners#show", as: "partners"
  post "/brexit-eu-funding/does-the-project-have-partners-or-participants-outside-the-uk" => "funding_form/partners#submit"
  get "/brexit-eu-funding/check-your-answers" => "funding_form/check_answers#show"
  post "/brexit-eu-funding/check-your-answers" => "funding_form/check_answers#submit"
  get "/brexit-eu-funding/confirmation" => "funding_form/confirmation#show"


  # Done pages
  constraints FormatRoutingConstraint.new("completed_transaction") do
    get "*slug", slug: %r{done/.+}, to: "completed_transaction#show"
  end

  # Simple Smart Answer pages
  get ":slug/y(/*responses)" => "simple_smart_answers#flow", :as => :smart_answer_flow
  constraints FormatRoutingConstraint.new("simple_smart_answer") do
    get ":slug", to: "simple_smart_answers#show", as: "simple_smart_answer"
    get ":slug/:part", to: redirect("/%{slug}") # Support for simple smart answers that were once a format with parts
  end

  # Transaction pages
  constraints FormatRoutingConstraint.new("transaction") do
    get ":slug(/:variant)", to: "transaction#show"
  end

  # Local Transaction pages
  constraints FormatRoutingConstraint.new("local_transaction") do
    get ":slug", to: "local_transaction#search", as: "local_transaction_search"
    post ":slug", to: "local_transaction#search"
    get ":slug/:local_authority_slug", to: "local_transaction#results", as: "local_transaction_results"
  end

  # Place pages
  constraints FormatRoutingConstraint.new("place") do
    get ":slug", to: "place#show"
    post ":slug", to: "place#show" # Support for postcode submission which we treat as confidential data
    get ":slug/:part", to: redirect("/%{slug}") # Support for places that were once a format with parts
  end

  # Licence pages
  constraints FormatRoutingConstraint.new("licence") do
    get ":slug", to: "licence#start", as: "licence"
    post ":slug", to: "licence#start" # Support for postcode submission which we treat as confidential data
    get ":slug/:authority_slug(/:interaction)", to: "licence#authority", as: "licence_authority"
  end

  # route API errors to the error handler
  constraints ApiErrorRoutingConstraint.new do
    get "*any", to: "error#handler"
  end

  mount GovukPublishingComponents::Engine, at: "/component-guide"
end
