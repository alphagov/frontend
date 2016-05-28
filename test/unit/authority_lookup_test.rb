require 'test_helper'
require 'authority_lookup'
require 'gds_api/test_helpers/mapit'

class AuthorityLookupTest < ActiveSupport::TestCase
  include GdsApi::TestHelpers::Mapit

  describe "#find_snac_from_slug" do
    setup do
      areas = [
        {
          "name"=>"Buckinghamshire County Council",
          "type"=>"CTY",
          "ons"=>"11",
          "gss"=>"E10000002",
          "govuk_slug"=>"buckinghamshire",
        }, 
        {
          "name"=>"Adur District Council",
          "type"=>"DIS",
          "ons"=>"45UB",
          "gss"=>"E07000223",
          "govuk_slug"=>"adur",
        }
      ]

      mapit_has_areas(AuthorityLookup.local_authority_types, areas)
    end

    should "return the correct snac given a slug" do
      assert_equal "11", AuthorityLookup.new(slug: "buckinghamshire").find_snac_from_slug
    end

    should "return nil when no result found for slug" do
      assert_equal nil, AuthorityLookup.new(slug: "narnia").find_snac_from_slug
    end
  end
end
