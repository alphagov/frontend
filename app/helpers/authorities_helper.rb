module AuthoritiesHelper
  def authorities_with_slugs
    Hash[AuthorityLookup.authorities.map {|slug, attributes|
      [ attributes['name'], slug ]
    }.sort]
  end
end
