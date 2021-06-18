class LocalTransactionPresenter < ContentItemPresenter
  PASS_THROUGH_DETAILS_KEYS = %i[
    introduction
    more_information
    need_to_know
    wales_availability
    scotland_availability
    northern_ireland_availability
  ].freeze

  PASS_THROUGH_DETAILS_KEYS.each do |key|
    define_method key do
      details[key.to_s] if details
    end
  end

  def unavailable?(country_name)
    details.dig(country_name_to_availability_key(country_name), "type") == "unavailable"
  end

  def devolved_administration_service?(country_name)
    details.dig(country_name_to_availability_key(country_name), "type") == "devolved_administration_service"
  end

  def devolved_administration_service_alternative_url(country_name)
    return unless devolved_administration_service?(country_name)

    details.dig(country_name_to_availability_key(country_name), "alternative_url")
  end

private

  def country_name_to_availability_key(country_name)
    "#{country_name.downcase.gsub(' ', '_')}_availability"
  end
end
