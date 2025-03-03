class OrganisationLogo < Logo
  attr_reader :url

  def initialize(logo, url)
    super(logo)
    @url = url
  end
end
