module Services
  def self.licensify
    @licensify ||= GdsApi::LicenceApplication.new(Plek.new.find("licensify"))
  end
end
