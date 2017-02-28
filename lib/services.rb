require 'statsd'
require 'gds_api/rummager'
require 'gds_api/content_store'

module Services
  def self.rummager
    @rummager ||= GdsApi::Rummager.new(Plek.new.find('search'))
  end

  def self.content_store
    @content_store ||= GdsApi::ContentStore.new(Plek.new.find('content-store'))
  end

  def self.licensify
    @licensify ||= GdsApi::LicenceApplication.new(Plek.new.find('licensify'))
  end

  def self.statsd
    @statsd ||= begin
      statsd_client = Statsd.new("localhost")
      statsd_client.namespace = ENV['GOVUK_STATSD_PREFIX'].to_s
      statsd_client
    end
  end
end
