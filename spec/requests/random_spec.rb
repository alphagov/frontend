RSpec.describe "Random" do
  context "with valid search results" do
    before do
      results = {
        "results" => [
          { "link" => "/bereavement-allowance" },
          { "link" => "/book-life-in-uk-test" },
          { "link" => "http://www.wyreforestdc.gov.uk" },
        ],
      }
      stub_request(:get, "#{Plek.new.find('search-api')}/search.json?count=0").to_return(status: 200, body: "{ \"total\": 3 }")
      stub_request(:get, /#{Plek.new.find('search-api')}\/search.json\?count=1&fields=link&start=./).to_return(status: 200, body: results.to_json)
    end

    it "redirects to one of the pages returned by search unless they start with http" do
      get "/random"
      expected_urls = ["#{Plek.new.website_root}/bereavement-allowance", "#{Plek.new.website_root}/book-life-in-uk-test"]
      unexpected_urls = ["#{Plek.new.website_root}/http://www.wyreforestdc.gov.uk"]

      expect(response).to have_http_status(:redirect)
      expect(expected_urls).to include(response.redirect_url)
      expect(response.redirect_url).not_to include(*unexpected_urls)
    end

    it "is cacheable long enough to discourage bots and short enough that users don't notice" do
      get "/random"

      expect(response.headers["Cache-Control"]).to eq("max-age=5, public")
    end
  end

  context "with invalid search results" do
    before do
      results = {
        "results" => [
          { "link" => "http://www.wyreforestdc.gov.uk" },
          { "link" => "/bereavement-allowance" },
          { "link" => "/book-life-in-uk-test" },
        ],
      }
      stub_request(:get, "#{Plek.new.find('search-api')}/search.json?count=0").to_return(status: 200, body: "{ \"total\": 3 }")
      stub_request(:get, /#{Plek.new.find('search-api')}\/search.json\?count=1&fields=link&start=./).to_return(status: 200, body: results.to_json)
    end

    it "does not redirect to URLs that start with 'http' and start again" do
      get "/random"

      expect(response).to redirect_to("#{Plek.new.website_root}/random")
    end

    it "does not cache the bad case where it redirects to /random" do
      get "/random"

      expect(response.headers["Cache-Control"]).to eq("max-age=0, public")
    end
  end
end
