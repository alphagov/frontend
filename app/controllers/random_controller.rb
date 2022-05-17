class RandomController < ApplicationController
  def random_page
    # Redirect to a random GOV.UK page, for fun.

    base_url = "#{Plek.new.find('search')}/search.json"
    total_documents = JSON.parse(RestClient.get("#{base_url}?count=0"))["total"]

    random_page_number = Random.rand(0..total_documents - 1)

    random_document = RestClient.get("#{base_url}?count=1&fields=link&start=#{random_page_number}")
    result = JSON.parse(random_document)["results"][0]["link"]

    # Some paths don't have leading slashes, so add them.
    result = "/#{result}" unless result.starts_with?("/")

    if result.starts_with?("/http")
      expires_in(0.seconds, public: true)
      redirect_to Frontend.govuk_website_root + random_path
    else
      expires_in(5.seconds, public: true)
      redirect_to Frontend.govuk_website_root + result
    end
  end
end
