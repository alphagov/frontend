namespace :rummager do
  desc "Reindex search engine"
  task :index => :environment do
    documents = [{
      "title" => "Help using GOV.UK",
      "description" => "Find out about GOV.UK, including the use of cookies, accessibility of the site, the privacy policy and terms and conditions of use.",
      "format" => "help_page",
      "link" => "/help",
      "indexable_content" => "",
    }]

    Rummageable.index(documents)
  end
end
