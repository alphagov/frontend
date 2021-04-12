class ElectoralPresenter
  def initialize(response)
    @response = response || {}
  end

  EXPECTED_KEYS = %w[
    address_picker
    addresses
    dates
    notifications
    ballots
    electoral_services
    registration
    postcode_location
  ].freeze

  EXPECTED_KEYS.each do |key|
    define_method key do
      response[key.to_s]
    end
  end

  def electoral_service_name
    electoral_services["name"]
  end

  def electoral_service_address
    if electoral_services["address"].present?
      electoral_services["address"].split("\\n").join("<br>")
    end
  end

  def registration_address
    if registration["address"].present?
      registration["address"].split("\\n").join("<br>")
    end
  end

private

  attr_reader :response
end
