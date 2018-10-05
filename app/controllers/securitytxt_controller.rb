class SecuritytxtController < ApplicationController
  include Cacheable

  def index
    render plain: securitytxt_content
  end

private

  def securitytxt_content
    <<~SECURITYTXT
      Contact: https://www.gov.uk/contact/govuk
      Permission: none
    SECURITYTXT
  end
end
