class AuthorityLookup
  cattr_accessor :authorities

  def self.find_slug(snac)
    self.load_authorities unless self.authorities
    self.authorities.key(snac.to_s) || false
  end

  def self.find_snac(slug)
    self.load_authorities unless self.authorities
    self.authorities[slug] || false
  end

  def self.load_authorities
    json = File.open( Rails.root.join('lib', 'data', 'authorities.json') ).read
    self.authorities = JSON.parse(json)
  end
end
