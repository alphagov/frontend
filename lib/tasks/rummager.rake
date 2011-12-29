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
    puts "Looking for rummager at: #{Rummeageable.host}"
    Rummageable.index documents
  end
end
