require "test_helper"
require "authority_lookup"
require "gds_api/test_helpers/mapit"

class AuthorityLookupTest < ActiveSupport::TestCase
  include GdsApi::TestHelpers::Mapit

  setup do
    example_area = {
      name: "Example Area",
      codes: {
        ons: "1",
        gss: "1",
        govuk_slug: "example-authority",
      },
    }

    stub_mapit_has_area_for_code("govuk_slug", "example-authority", example_area)
    stub_mapit_does_not_have_area_for_code("govuk_slug", "does-not-exist")
  end

  should "return the correct snac code given a valid slug" do
    assert_equal "1", AuthorityLookup.find_snac_from_slug("example-authority")
  end

  should "return nil given a slug which doesn't exist" do
    assert_nil AuthorityLookup.find_snac_from_slug("does-not-exist")
  end
end
