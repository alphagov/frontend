class SpecialistSectorPresenter
  attr_reader :artefact, :sector

  delegate :web_url, to: :artefact

  def initialize(artefact, sector)
    @artefact = artefact
    @sector = sector
  end

  # This strips away the initial part of an item title if it contains the
  # title of the current specialist sector to remove any duplication. The
  # leading character of the remainder of the title is then upcased.
  #
  # eg. "Oil and gas: wells" -> "Wells"
  #
  def title
    pattern = /\A#{Regexp.escape(sector.title)}: /

    if artefact.title =~ pattern
      title = artefact.title.sub(pattern, '')
      title[0] = title[0].upcase
      title
    else
      artefact.title
    end
  end
end
