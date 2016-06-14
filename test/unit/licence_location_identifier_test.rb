require 'test_helper'
require 'licence_location_identifier'

class LicenceLocationIdentifierTest < ActiveSupport::TestCase
  context "given an artefact exists with a local service for the district/unitary tiers" do
    setup do
      @artefact = { "details" => { "licence" => { "local_service" => { "providing_tier" => [ "county", "unitary" ] } } } }
    end

    should "select the correct tier authority from areas providing a district and county" do
      areas = [
        { type: "CTY", govuk_slug: "lancs"},
        { type: "DIS", govuk_slug: "ribble"},
        { type: "CED" },
        { type: "WMC" }
      ]
      slug = LicenceLocationIdentifier.find_slug(areas, @artefact)

      assert_equal "lancs", slug
    end

    should "return nil if no authorities match" do
      areas = [
        { type: "CED" },
        { type: "WMC" }
      ]
      slug = LicenceLocationIdentifier.find_slug(areas, @artefact)

      assert_nil slug
    end

    should "select the closest authority from areas if district not provided" do
      areas = [
        {type: "DIS", govuk_slug: "ribble"},
        {type: "CED" },
        {type: "WMC" }
      ]
      slug = LicenceLocationIdentifier.find_slug(areas, @artefact)

      assert_equal "ribble", slug
    end
  end

  context "given no local service is available" do
    should "select the closest authority for a areas providing county and district" do
      areas = [
        { type: "CTY", govuk_slug: "lancs"},
        { type: "DIS", govuk_slug: "ribble"},
      ]
      slug = LicenceLocationIdentifier.find_slug(areas)

      assert_equal "ribble", slug
    end

    should "select the closest authority for a areas providing unitary authority" do
      areas = [
        { type: "UTA", govuk_slug: "shrops"},
        { type: "CPC" }
      ]
      slug = LicenceLocationIdentifier.find_slug(areas)

      assert_equal "shrops", slug
    end

    should "return nil when a areas does not provide an appropriate authority" do
      areas = [
        { type: "CED" },
        { type: "WMC" }
      ]
      slug = LicenceLocationIdentifier.find_slug(areas)

      assert_nil slug
    end

    should "return nil when a areas does not provide any authorities" do
      areas = []
      slug = LicenceLocationIdentifier.find_slug(areas)

      assert_nil slug
    end
  end
end
