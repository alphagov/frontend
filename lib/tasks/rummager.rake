require 'indexable_support_page_set'

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

    support_pages = IndexableSupportPageSet.new.pages.map(&:to_hash)
    documents = documents + support_pages
    Rummageable.index(documents)
  end
end
