module ElectionHelpers
  TEST_API_URL = "https://test.example.org/api/v1".freeze
  TEST_API_KEY = "LetMeIn".freeze

  def with_electoral_api_url(&block)
    ClimateControl.modify ELECTIONS_API_URL: TEST_API_URL, ELECTIONS_API_KEY: TEST_API_KEY, &block
  end

  def stub_api_postcode_lookup(postcode, response: "{}", status: 200)
    stub_request(:get, "#{TEST_API_URL}/postcode/#{postcode}?token=#{TEST_API_KEY}")
      .to_return(status:, body: response)
  end

  def stub_api_address_lookup(uprn, response: "{}", status: 200)
    stub_request(:get, "#{TEST_API_URL}/address/#{uprn}?token=#{TEST_API_KEY}")
      .to_return(status:, body: response)
  end

  def api_response
    path = Rails.root.join("test/fixtures/electoral-result.json")
    File.read(path)
  end
end
