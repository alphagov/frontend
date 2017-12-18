require 'gds_api/content_store'

module Services
  def self.content_store
    @content_store ||= GdsApi::ContentStore.new(Plek.new.find('content-store'))
  end

  def self.licensify
    @licensify ||= GdsApi::LicenceApplication.new(Plek.new.find('licensify'))
  end
end
