require_relative "../../app/helpers/draft_helper"

# rubocop:disable Style/MixinUsage
include DraftHelper
# rubocop:enable Style/MixinUsage

GovukContentSecurityPolicy.configure do |policy|
  # The map block makes use of the OS api and inline styles
  policy.img_src(*policy.img_src, "https://api.os.uk", :data)
  # The map component makes use of maplibre
  policy.img_src(*policy.img_src, "https://tiles.openfreemap.org", :data)
  policy.connect_src(*policy.connect_src, "https://tiles.openfreemap.org", :data)

  # The draft stack uses a parser-blocking script tag to force the Asset
  # Manager authentication handshake before the rest of the page is parsed.
  policy.script_src(*policy.script_src, "*.publishing.service.gov.uk") if draft_host?
end
