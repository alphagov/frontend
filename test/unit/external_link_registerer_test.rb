require 'gds_api/external_link_tracker'
require "test_helper"
require "external_link_registerer"

class ExternalLinkRegistererTest < ActiveSupport::TestCase
  test "#register sends links to the external link tracker" do

    beta_tax_disc_service_url = 'https://www.taxdisc.service.gov.uk'
    orig_tax_disc_service_url = 'https://www.taxdisc.direct.gov.uk/EvlPortalApp/app/home/intro?skin=directgov'

    GdsApi::ExternalLinkTracker.any_instance
                               .expects(:add_external_link)
                               .with(beta_tax_disc_service_url)

    GdsApi::ExternalLinkTracker.any_instance
                               .expects(:add_external_link)
                               .with(orig_tax_disc_service_url)

    ExternalLinkRegisterer.new.register_links([beta_tax_disc_service_url, orig_tax_disc_service_url])
  end
end
