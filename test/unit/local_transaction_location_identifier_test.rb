require 'test_helper'
require 'local_transaction_location_identifier'

class LocalTransactionLocationIdentifierTest < ActiveSupport::TestCase
  context "given an artefact exists with a local service for the district/unitary tiers" do
    setup do
      @artefact = { "details" => { "local_service" => { "providing_tier" => %w(district unitary) } } }
    end

    should "select the correct tier authority from geostack providing a district and county" do
      areas = [
        {type: "CTY", govuk_slug: "lancashire"},
        {type: "DIS", govuk_slug: "ribble"},
        {type: "CED" },
        {type: "WMC" }
      ]

      slug = LocalTransactionLocationIdentifier.find_slug(areas, @artefact)

      assert_equal "ribble", slug
    end

    should "return nil if no authorities match" do
      areas = [
        { type: "CED" },
        { type: "WMC" },
      ]
      slug = LocalTransactionLocationIdentifier.find_slug(areas, @artefact)

      assert_nil slug
    end
  end

  context "given an artefact exists with a local service for the county/unitary tiers" do
    setup do
      @artefact = { "details" => { "local_service" => { "providing_tier" => %w(county unitary) } } }
    end

    should "select the correct tier authority from geostack providing a district and county" do
      areas = [
        {type: "CTY", govuk_slug: "lancashire"},
        {type: "DIS", govuk_slug: "ribble"},
        {type: "CED" },
        {type: "WMC" }
      ]
      slug = LocalTransactionLocationIdentifier.find_slug(areas, @artefact)

      assert_equal "lancashire", slug
    end

    should "select the correct tier authority from geostack providing a unitary authority" do
      areas = [
        { type: "UTA", govuk_slug: "shrops"},
        { type: "CPC" }
      ]

      slug = LocalTransactionLocationIdentifier.find_slug(areas, @artefact)

      assert_equal "shrops", slug
    end
  end
end
