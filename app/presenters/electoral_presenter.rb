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
    if electoral_services["address"].present?
      electoral_services["address"].split("\\n").join("<br>").html_safe
    end
  end

  def presented_registration_address
    if registration["address"].present?
      registration["address"].split("\\n").join("<br>").html_safe
    end
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

private

  attr_reader :response

  def duplicate_contact_details?
    if electoral_services["address"].present? && registration["address"].present?
      electoral_services["address"].gsub(/\s+/, "") == registration["address"].gsub(/\s+/, "")
    end
  end

  def present_ballots(date)
    if date["ballots"].present?
      date["ballots"].map { |b| "#{b['poll_open_date']} - #{b['ballot_title']}" }
    end
  end
end
