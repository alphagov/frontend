require 'test_helper'
require 'local_transaction_location_identifier'

class LocalTransactionLocationIdentifierTest < ActiveSupport::TestCase
  context "given an artefact exists with a local service for the district/unitary tiers" do
    setup do
      @artefact = { "details" => { "local_service" => { "providing_tier" => [ "district", "unitary" ] } } }
    end

    should "select the correct tier authority from geostack providing a district and county" do
      geostack = {
        "areas" => {
          1 => {"id" => 1, "codes" => {"ons" => "30"}, "name" => "Lancashire City Council", "type" => "CTY" },
          2 => {"id" => 2, "codes" => {"ons" => "30UN"}, "name" => "South Ribble Borough Council", "type" => "DIS" },
          3 => {"id" => 3, "codes" => {"unit_id" => "43006"}, "name" => "Leyland South West", "type" => "CED"},
          4 => {"id" => 4, "codes" => {"unit_id" => "24783"}, "name" => "South Ribble", "type" => "WMC"}
        }
      }
      snac = LocalTransactionLocationIdentifier.find_snac(geostack, @artefact)

      assert_equal "30UN", snac
    end

    should "return nil if no authorities match" do
      geostack = {
        "areas" => {
          3 => {"id" => 3, "codes" => {"unit_id" => "43006"}, "name" => "Leyland South West", "type" => "CED"},
          4 => {"id" => 4, "codes" => {"unit_id" => "24783"}, "name" => "South Ribble", "type" => "WMC"}
        }
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
        "areas" => {
          1 => {"id" => 1, "codes" => {"ons" => "30"}, "name" => "Lancashire City Council", "type" => "CTY" },
          2 => {"id" => 2, "codes" => {"ons" => "30UN"}, "name" => "South Ribble Borough Council", "type" => "DIS" },
          3 => {"id" => 3, "codes" => {"unit_id" => "43006"}, "name" => "Leyland South West", "type" => "CED"},
          4 => {"id" => 4, "codes" => {"unit_id" => "24783"}, "name" => "South Ribble", "type" => "WMC"}
        }
      }
      snac = LocalTransactionLocationIdentifier.find_snac(geostack, @artefact)

      assert_equal "30", snac
    end

    should "select the correct tier authority from geostack providing a unitary authority" do
      geostack = {
        "areas" => {
          1 => {"id" => 1, "codes" => {"ons" => "00GG"}, "name" => "Shropshire Council", "type" => "UTA" },
          2 => {"id" => 2, "codes" => {"ons" => "00GG162"}, "name" => "Shrewsbury", "type" => "CPC" }
        }
      }
      snac = LocalTransactionLocationIdentifier.find_snac(geostack, @artefact)

      assert_equal "00GG", snac
    end
  end

end
