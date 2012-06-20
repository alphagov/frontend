
# View helper for all things related to parts as provided by
# the Parted module.
module PartHelper
  def part_path(slug, part=nil, edition=nil)
    opts = Hash[{slug: slug, part: part, edition: edition}.select { |k,v| v }]
    publication_path(opts)
  end

  def previous_part_path(model, part, edition)
    part_path(model.slug, model.part_before(part).slug, edition)
  end

  def next_part_path(model, part, edition)
    part_path(model.slug, model.part_after(part).slug, edition)
  end
end