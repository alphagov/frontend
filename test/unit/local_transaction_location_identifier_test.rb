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
          {"id" => 1, "name" => "Lancashire County Council", "type" => "CTY", "ons" => "30"},
          {"id" => 2, "name" => "South Ribble Borough Council", "type" => "DIS", "ons" => "30UN"},
          {"id" => 3, "name" => "Leyland South West", "type" => "CED" },
          {"id" => 4, "name" => "South Ribble", "type" => "WMC" }
        ]
      }
      snac = LocalTransactionLocationIdentifier.find_snac(geostack, @artefact)

      assert_equal "30UN", snac
    end

    should "return nil if no authorities match" do
      geostack = {
        "council" => [
          {"id" => 3, "name" => "Leyland South West", "type" => "CED" },
          {"id" => 4, "name" => "South Ribble", "type" => "WMC" }
        ]
      }
      snac = LocalTransactionLocationIdentifier.find_snac(geostack, @artefact)

      assert_nil snac
    end
  end

  context "given an artefact exists with a local service for the county/unitary tiers" do
    setup do
      @artefact = { "details" => { "local_service" => { "providing_tier" => [ "county", "unitary" ] } } }
    end

    should "select the correct tier authority from geostack providing a district and county" do
      geostack = {
        "council" => [
          {"id" => 1, "name" => "Lancashire County Council", "type" => "CTY", "ons" => "30"},
          {"id" => 2, "name" => "South Ribble Borough Council", "type" => "DIS", "ons" => "30UN"},
          {"id" => 3, "name" => "Leyland South West", "type" => "CED" },
          {"id" => 4, "name" => "South Ribble", "type" => "WMC" }
        ]
      }
      snac = LocalTransactionLocationIdentifier.find_snac(geostack, @artefact)

      assert_equal "30", snac
    end

    should "select the correct tier authority from geostack providing a unitary authority" do
      geostack = {
        "council" => [
          {"id" => 2, "name" => "Shropshire Council", "type" => "UTA", "ons" => "00GG"},
          {"id" => 3, "name" => "Shrewsbury", "type" => "CPC" }
        ]
      }
      snac = LocalTransactionLocationIdentifier.find_snac(geostack, @artefact)

      assert_equal "00GG", snac
    end
  end

end
