require 'test_helper'
require 'licence_location_identifier'

class LicenceLocationIdentifierTest < ActiveSupport::TestCase
  context "given an artefact exists with a local service for the district/unitary tiers" do
    setup do
      @artefact = { "details" => { "licence" => { "local_service" => { "providing_tier" => [ "county", "unitary" ] } } } }
    end

    should "select the correct tier authority from geostack providing a district and county" do
      geostack = {
        "council" => [
          {"id" => 1, "name" => "Lancashire County Council", "type" => "CTY", "govuk_slug" => "lancashire-county-council"},
          {"id" => 2, "name" => "South Ribble Borough Council", "type" => "DIS", "govuk_slug" => "south-ribble-borough-council"},
          {"id" => 3, "name" => "Leyland South West", "type" => "CED" },
          {"id" => 4, "name" => "South Ribble", "type" => "WMC" }
        ]
      }
      slug = LicenceLocationIdentifier.find_slug(geostack, @artefact)

      assert_equal "lancashire-county-council", slug
    end

    should "return nil if no authorities match" do
      geostack = {
        "council" => [
          {"id" => 3, "name" => "Leyland South West", "type" => "CED" },
          {"id" => 4, "name" => "South Ribble", "type" => "WMC" }
        ]
      }
      slug = LicenceLocationIdentifier.find_slug(geostack, @artefact)

      assert_nil slug
    end

    should "select the closest authority from geostack if district not provided" do
      geostack = {
        "council" => [
          {"id" => 2, "name" => "South Ribble Borough Council", "type" => "DIS", "govuk_slug" => "south-ribble-borough-council"},
          {"id" => 3, "name" => "Leyland South West", "type" => "CED" },
          {"id" => 4, "name" => "South Ribble", "type" => "WMC" }
        ]
      }
      slug = LicenceLocationIdentifier.find_slug(geostack, @artefact)

      assert_equal "south-ribble-borough-council", slug
    end
  end

  context "given no local service is available" do
    should "select the closest authority for a geostack providing county and district" do
      geostack = {
        "council" => [
          {"id" => 2230, "name" => "Lancashire County Council", "type" => "CTY", "govuk_slug" => "lancashire-county-council"},
          {"id" => 2363, "name" => "South Ribble Borough Council", "type" => "DIS", "govuk_slug" => "south-ribble-borough-council"}
        ]
      }
      slug = LicenceLocationIdentifier.find_slug(geostack)

      assert_equal "south-ribble-borough-council", slug
    end

    should "select the closest authority for a geostack providing unitary authority" do
      geostack = {
        "council" => [
          {"id" => 1, "name" => "Shropshire Council", "type" => "UTA", "govuk_slug" => "shropshire-council"},
          {"id" => 2, "name" => "Shrewsbury", "type" => "CPC" }
        ]
      }
      slug = LicenceLocationIdentifier.find_slug(geostack)

      assert_equal "shropshire-council", slug
    end

    should "return nil when a geostack does not provide an appropriate authority" do
      geostack = {
        "council" => [
          {"id" => 1, "name" => "Leyland South West", "type" => "CED" },
          {"id" => 2, "name" => "South Ribble", "type" => "WMC" }
        ]
      }
      slug = LicenceLocationIdentifier.find_slug(geostack)

      assert_nil slug
    end

    should "return nil when a geostack does not provide any authorities" do
      geostack = {
        "council" => [ ]
      }
      slug = LicenceLocationIdentifier.find_slug(geostack)

      assert_nil slug
    end
  end
end
