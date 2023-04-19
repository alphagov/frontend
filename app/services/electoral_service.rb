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
        response = RestClient.get(request_url, {})
        report_status_code(response.code)
        JSON.parse(response)
      end
    rescue RestClient::Exception => e
      report_status_code(e.http_code)
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

  def report_status_code(code)
    GovukStatsd.increment("elections_api.#{monitoring_path}.#{code}")
  end

  def with_caching(&block)
    Rails.cache.fetch(request_url, expires_in: 1.minute) do
      GovukStatsd.time("elections_api.#{monitoring_path}.request_time", &block)
    end
  end

  def monitoring_path
    postcode.present? ? "postcode" : "address"
  end

  def request_url
    endpoint = postcode.present? ? "postcode/#{postcode}" : "address/#{uprn}"
    "#{api_base_path}/#{endpoint}?token=#{ENV['ELECTIONS_API_KEY']}"
  end

  def api_base_path
    ENV["ELECTIONS_API_URL"]
  end
end
