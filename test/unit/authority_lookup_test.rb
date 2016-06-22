require 'test_helper'
require 'authority_lookup'
require 'gds_api/test_helpers/mapit'

class AuthorityLookupTest < ActiveSupport::TestCase
  include GdsApi::TestHelpers::Mapit

  setup do
    another_area = {
      name: "Test Area",
      codes: {
        ons: "2",
        gss: "2345678",
        govuk_slug: "another-authority",
      }
    }

    example_area = {
      name: "Example Area",
      codes: {
        ons: "1",
        gss: "1",
        govuk_slug: "example-authority"
      }
    }

    mapit_has_area_for_code('ons', '2', another_area)
    mapit_has_area_for_code('govuk_slug', 'example-authority', example_area)
    mapit_does_not_have_area_for_code('ons', '12345')
    mapit_does_not_have_area_for_code('govuk_slug', 'does-not-exist')
  end

  should "return the correct slug given a valid snac code as a string" do
    assert_equal "another-authority", AuthorityLookup.find_slug_from_snac('2')
  end

  should "return the correct slug given a valid snac code as an integer" do
    assert_equal "another-authority", AuthorityLookup.find_slug_from_snac(2)
  end

  should "return nil given a snac which doesn't exist" do
    assert_nil AuthorityLookup.find_slug_from_snac(12345)
  end

  should "return the correct snac code given a valid slug" do
    assert_equal "1", AuthorityLookup.find_snac_from_slug("example-authority")
  end

  should "return nil given a slug which doesn't exist" do
    assert_nil AuthorityLookup.find_snac_from_slug("does-not-exist")
  end
end
