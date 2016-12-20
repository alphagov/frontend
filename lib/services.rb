require 'gds_api/rummager'

module Services
  def self.rummager
    @rummager ||= GdsApi::Rummager.new(Plek.new.find('search'))
  end
end
