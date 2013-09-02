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

    # Remove old support pages from search.
    # This can be removed once it's run on production
    old_support_pages = %w(
      about-govuk
      accessibility
      apis
      broken-pages
      browsers
      cookies
      directgov-businesslink
      government-gateway
      health
      jobs-employment-tools
      linking-to-govuk
      privacy-policy
      student-finance
      terms-conditions
      wales-scotland-ni
    )
    old_support_pages.each do |slug|
      Rummageable.delete("/support/#{slug}")
    end
  end
end
