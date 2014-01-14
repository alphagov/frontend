module Frontend
  mattr_accessor :industry_sectors_browse_enabled
end

if Rails.env.production?
  Frontend.industry_sectors_browse_enabled = false
else
  Frontend.industry_sectors_browse_enabled = true
end
