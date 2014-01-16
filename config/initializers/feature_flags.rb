require 'frontend'

module Frontend
  def self.industry_sectors_browse_enabled?
    Rails.env.development? || Rails.env.test?
  end
end
