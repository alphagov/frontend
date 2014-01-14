class ActiveSupport::TestCase
  def api_returns_404_for(path)
    body = {
      "_response_info" => {
        "status" => "not found"
      }
    }
    url = "#{Plek.current.find("contentapi")}#{path}"
    stub_request(:get, url).to_return(:status => 404, :body => body.to_json, :headers => {})
  end
end
