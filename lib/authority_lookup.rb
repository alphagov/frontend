class AuthorityLookup
  cattr_accessor :authorities

  def self.find_slug_from_snac(snac)
    self.authorities.select {|slug, codes| codes["ons"] == snac.to_s }.keys.first || false
  end

  def self.find_slug_from_gss(gss)
    self.authorities.select {|slug, codes| codes["gss"] == gss.to_s }.keys.first || false
  end

  def self.find_snac(slug)
    return self.authorities[slug]["ons"] if self.authorities[slug]
    return false
  end

  def self.find_gss(slug)
    return self.authorities[slug]["gss"] if self.authorities[slug]
    return false
  end

  def self.authorities
    @@authorities || self.load_authorities
  end

  def self.load_authorities
    json = File.open( Rails.root.join('lib', 'data', 'authorities.json') ).read
    self.authorities = JSON.parse(json)
  end
end
