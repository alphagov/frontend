class HashLikeOpenStruct < OpenStruct
  def [](field)
    self.send(field)
  end
end

class ArtefactUnavailable < HashLikeOpenStruct
end

module ArtefactHelpers
  def artefact_unavailable
    ArtefactUnavailable.new(
        details: HashLikeOpenStruct.new(format: 'missing', need_id: 'missing'), 
        tags: [], 
        related: [])
  end

  # Duplicated in Slimmer
  def root_primary_section(artefact)
    primary_section = artefact["tags"].detect do |tag| 
      tag["details"]["type"] == "section"
    end

    if primary_section.nil?
      nil
    else
      if primary_section["parent"]
        primary_section["parent"]
      else
        primary_section
      end
    end
  end
end
