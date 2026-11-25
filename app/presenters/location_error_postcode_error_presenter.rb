class LocationErrorPostcodeErrorPresenter < PostcodeLookupErrorPresenter
  def initialize(location_error)
    super
    @message = I18n.translate(location_error.message)
    @message_for_ga4 = I18n.translate(location_error.message, locale: :en)
  end
end
