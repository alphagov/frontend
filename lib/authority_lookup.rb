class AuthorityLookup
  cattr_accessor :authorities

  def self.find_slug_from_snac(snac)
    self.find_slug_from_code("ons", snac)
  end

  def self.find_slug_from_gss(gss)
    self.find_slug_from_code("gss", gss)
  end

  def self.find_snac(slug)
    self.find_code("ons", slug)
  end

  def self.find_gss(slug)
    self.find_code("gss", slug)
  end

  def self.load_authorities
    json = File.open(Rails.root.join("lib", "data", "authorities.json")).read
    self.authorities = JSON.parse(json)
  end

  private

  def self.find_code(type, slug)
    self.load_authorities unless self.authorities
    return self.authorities[slug][type] if self.authorities[slug]
    nil
  end

  def self.find_slug_from_code(type, code)
    self.load_authorities unless self.authorities
    self.authorities.select do |slug, codes|
      codes[type] == code.to_s
    end.keys.first
  end
end
