require 'ostruct'

class TravelAdviceCountryPresenter < PublicationPresenter

  def image
    @image ||= OpenStruct.new(details["image"]) if details["image"]
  end

  def document
    @document ||= OpenStruct.new(details["document"]) if details["document"]
  end

  def country_name
    country['name']
  end
end
