class ElectoralService
  attr_reader :body, :error

  def initialize(postcode: nil, uprn: nil)
    @postcode, @uprn = postcode, uprn
    @error = nil
    @body = nil
  end

  def make_request
    @body = begin
              json = RestClient.get(request_url, headers)
              JSON.parse(json)
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
    if [400, 404].include? exception.http_code
      if postcode
        "validPostcodeNoElectionsMatch"
      else
        "validUprnNoElectionsMatch"
      end
    end
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
