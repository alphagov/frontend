class ElectoralService
  attr_reader :body, :error

  def initialize(postcode: nil, uprn: nil)
    @postcode = postcode
    @uprn = uprn
    @error = nil
    @body = nil
  end

  def make_request
    @body = begin
              with_caching do
                json = RestClient.get(request_url, headers)
                JSON.parse(json)
              end
            rescue RestClient::Exception => e
              @error = assemble_error(e)
              {}
            end
  end

  def ok?
    error.nil? && body.present?
  end

  def error?
    error.present?
  end

private

  attr_reader :postcode, :uprn

  def assemble_error(exception)
    report_error(exception.http_code)

    if [400, 404].include? exception.http_code
      if postcode
        "validPostcodeNoElectionsMatch"
      else
        "validUprnNoElectionsMatch"
      end
    else
      raise
    end
  end

  def report_error(code)
    GovukStatsd.increment("elections.errors.#{code}")
  end

  def with_caching
    Rails.cache.fetch(request_url, expires_in: 1.minute) do
      GovukStatsd.time("content_store.#{timing_endpoint}.request_time") do
        yield
      end
    end
  end

  def timing_endpoint
    postcode.present? ? "postcode" : "address"
  end

  def request_url
    endpoint = postcode.present? ? "postcode/#{postcode}" : "address/#{uprn}"
    "#{api_base_path}/#{endpoint}"
  end

  def headers
    {
      Authorization: "Token #{ENV['ELECTIONS_API_KEY']}",
    }
  end

  def api_base_path
    ENV["ELECTIONS_API_URL"]
  end
end
