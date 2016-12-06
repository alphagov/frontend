class ActiveSupport::TestCase
  def api_returns_404_for(path)
    body = {
      "_response_info" => {
        "status" => "not found"
      }
    }
    url = "#{Plek.new.find('contentapi')}#{path}"
    stub_request(:get, url).to_return(status: 404, body: body.to_json, headers: {})
  end

  def api_times_out_for(path)
    url = "#{Plek.new.find('contentapi')}#{path}"
    stub_request(:get, url).to_timeout
  end

  def api_returns_error_for(path, error_code)
    url = "#{Plek.new.find('contentapi')}#{path}"
    stub_request(:get, url).to_return(status: error_code, body: '', headers: {})
  end

  def api_fails_to_connect_for(path)
    url = "#{Plek.new.find('contentapi')}#{path}"
    stub_request(:get, url).to_raise(Errno::ECONNREFUSED)
  end
end
