class ElectoralPresenter
  def initialize(response)
    @response = response || {}
  end

  EXPECTED_KEYS = %w[
    address_picker
    addresses
    dates
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

private

  attr_reader :response
end
