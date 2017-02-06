require 'gds_api/rummager'
require 'gds_api/content_store'

module Services
  def self.rummager
    @rummager ||= GdsApi::Rummager.new(Plek.new.find('search'))
  end

  def self.content_store
    @content_store ||= GdsApi::ContentStore.new("http://content-store.dev.gov.uk")
  end
end
