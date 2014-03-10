module Frontend
  mattr_accessor :organisations_search_client
  mattr_accessor :combined_search_client
  mattr_accessor :detailed_guidance_content_api
  mattr_accessor :mapit_api

  def self.specialist_sectors
    [
      "oil-and-gas",
      "immigration-operational-guidance",
    ]
  end
end
