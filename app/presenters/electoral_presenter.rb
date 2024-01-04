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
    electoral_services["name"] if electoral_services.present?
  end

  def presented_electoral_service_address
    address_lines(electoral_services)
  end

  def presented_registration_address
    address_lines(registration)
  end

  def upcoming_elections
    dates.flat_map { |date| present_ballots(date) } if dates.present?
  end

  def use_electoral_services_contact_details?
    electoral_services.present? && !duplicate_contact_details?
  end

  def use_registration_contact_details?
    registration.present?
  end

  def show_picker?
    address_picker.present? && no_contact_details?
  end

private

  attr_reader :response

  def address_lines(property)
    if property["address"].present?
      property["address"].split("\n")
    end
  end

  def duplicate_contact_details?
    if electoral_services["address"].present? && registration["address"].present?
      electoral_services["address"].gsub(/\s+/, "") == registration["address"].gsub(/\s+/, "")
    end
  end

  def no_contact_details?
    registration.nil? && electoral_services.nil?
  end
end
