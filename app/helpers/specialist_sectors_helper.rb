module SpecialistSectorsHelper

  # This strips away the initial part of an item title if it contains the
  # title of the current specialist sector to remove any duplication. The
  # leading character of the remainder of the title is then upcased.
  #
  # eg. "Oil and gas: wells" -> "Wells"
  #
  def specialist_sector_item_title(title, sector)
    pattern = /\A#{Regexp.escape(sector.title)}: /

    if title =~ pattern
      title = title.sub(pattern, '')
      title[0] = title[0].upcase
    end
    title
  end
end
