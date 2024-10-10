RSpec.describe "Get Involved" do
    include GovukAbTesting::RspecHelpers
    include Capybara::RSpecMatchers
  
    let(:url) { "http://content-store.dev.gov.uk/content/government/get-involved" }
  
    context "GET index" do
      before do  
        stub_request(:get, url)
          .with(
            headers: {
              'Accept' => 'application/json',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host' => 'content-store.dev.gov.uk',
              'User-Agent' => 'gds-api-adapters/96.0.3 ()'
            }
          )
          .to_return(status: 200,
          body: {
            schema_name: "get_involved"
          }.to_json,
          headers: { 'Content-Type' => 'application/json' })

          stub_request(:get, "http://content-store.dev.gov.uk/content/government")
          .with(headers: {
            'Accept' => 'application/json',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Host' => 'content-store.dev.gov.uk',
            'User-Agent' => 'gds-api-adapters/96.0.3 ()'
          })
          .to_return(status: 200, body: {
            schema_name: "get_involved"
          }.to_json,
          headers: { 'Content-Type' => 'application/json' })
      end
          
      it "responds with success and correct body" do
        get "/government/get-involved"
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("get_involved")
      end
    end
  end