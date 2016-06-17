require 'test_helper'
require 'local_transaction_location_identifier'

class LocalTransactionLocationIdentifierTest < ActiveSupport::TestCase
  context "given an artefact exists with a local service for the district/unitary tiers" do
    setup do
      @artefact = { "details" => { "local_service" => { "providing_tier" => [ "district", "unitary" ] } } }
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
      slug = LocalTransactionLocationIdentifier.find_slug(geostack, @artefact)

      assert_equal "south-ribble-borough-council", slug
    end

    should "return nil if no authorities match" do
      geostack = {
        "council" => [
          {"id" => 3, "name" => "Leyland South West", "type" => "CED" },
          {"id" => 4, "name" => "South Ribble", "type" => "WMC" }
        ]
      }
      slug = LocalTransactionLocationIdentifier.find_slug(geostack, @artefact)

      assert_nil slug
    end
  end

  context "given an artefact exists with a local service for the county/unitary tiers" do
    setup do
      @artefact = { "details" => { "local_service" => { "providing_tier" => [ "county", "unitary" ] } } }
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
      slug = LocalTransactionLocationIdentifier.find_slug(geostack, @artefact)

      assert_equal "lancashire-county-council", slug
    end

    should "select the correct tier authority from geostack providing a unitary authority" do
      geostack = {
        "council" => [
          {"id" => 2, "name" => "Shropshire Council", "type" => "UTA", "govuk_slug" => "shropshire-council"},
          {"id" => 3, "name" => "Shrewsbury", "type" => "CPC" }
        ]
      }
      slug = LocalTransactionLocationIdentifier.find_slug(geostack, @artefact)

      assert_equal "shropshire-council", slug
    end
  end

end
