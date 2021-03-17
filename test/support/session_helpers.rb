module SessionHelpers
  def mock_logged_in_session
    request.headers["GOVUK-Account-Session"] = "placeholder"
  end
end
