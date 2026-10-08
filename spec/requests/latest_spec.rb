RSpec.describe "Latest" do
  include GdsApi::TestHelpers::Search
  before do
    results = {
      "results" => [
        { "link" => "/book-life-in-uk-test" },
      ],
    }
    stub_any_search.to_return(body: results.to_json)
  end

  it "redirects to the most recently updated page, as returned by search" do
    get "/latest"
    expected_url = "#{Plek.new.website_root}/book-life-in-uk-test"

    expect(response).to have_http_status(:redirect)
    expect(expected_url).to eq(response.redirect_url)
  end

  it "is cacheable long enough to discourage bots and short enough that users don't notice" do
    get "/latest"

    expect(response.headers["Cache-Control"]).to eq("max-age=5, public")
  end

  it "calls search with a parameter to filter out external links" do
    get "/latest"

    expect(WebMock)
      .to have_requested(:get, "#{Plek.new.find('search-api')}/search.json")
      .with(query: hash_including({ reject_format: "recommended-link" }))
  end
end
