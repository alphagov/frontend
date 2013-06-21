require 'indexable_support_page_set'

namespace :rummager do
  desc "Reindex search engine"
  task :index => :environment do
    documents = [{
      "title" => "Help",
      "description" => "Get help using the site.",
      "format" => "page",
      "link" => "/help",
      "indexable_content" => "help assistance",
    }]

    support_pages = IndexableSupportPageSet.new.pages.map(&:to_hash)
    documents = documents + support_pages
    Rummageable.index(documents)
  end
end
