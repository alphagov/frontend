class DemocracyClubApiResponse
  attr_reader :error, :body

  def initialize(body, error)
    @error = error
    @body = body
  end

  def bad_request?
    error == "bad_request"
  end
end
