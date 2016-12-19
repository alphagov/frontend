class PublicationWithPlacesPresenter < PublicationPresenter
  attr_accessor :places

  def initialize(artefact, places = nil)
    @artefact = artefact
    @places = places if places
  end

  def places
    if @places
      @places.map do |place|
        place['text']    = place['url'].truncate(36) if place['url']
        place['address'] = [place['address1'], place['address2']].compact.map(&:strip).join(", ")
        place
      end
    end
  end
end
