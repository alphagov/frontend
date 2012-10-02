require 'test_helper'
require 'licence_location_identifier'

class LicenceLocationIdentifierTest < ActiveSupport::TestCase
  should "select the closest authority for a geostack providing county and district" do
    geostack = {
      "areas" => {
        1 => {"id" => 1, "codes" => {"ons" => "30"}, "name" => "Lancashire City Council", "type" => "CTY" },
        2 => {"id" => 2, "codes" => {"ons" => "30UN"}, "name" => "South Ribble Borough Council", "type" => "DIS" },
        3 => {"id" => 3, "codes" => {"unit_id" => "43006"}, "name" => "Leyland South West", "type" => "CED"},
        4 => {"id" => 4, "codes" => {"unit_id" => "24783"}, "name" => "South Ribble", "type" => "WMC"}
      }
    }
    snac = LicenceLocationIdentifier.find_snac(geostack)

    assert_equal "30UN", snac
  end

  should "select the closest authority for a geostack providing unitary authority" do
    geostack = {
      "areas" => {
          1 => {"id" => 1, "codes" => {"ons" => "00GG"}, "name" => "Shropshire Council", "type" => "UTA" },
          2 => {"id" => 2, "codes" => {"ons" => "00GG162"}, "name" => "Shrewsbury", "type" => "CPC" }
      }
    }
    snac = LicenceLocationIdentifier.find_snac(geostack)

    assert_equal "00GG", snac
  end

  should "return nil when a geostack does not provide an appropriate authority" do
    geostack = {
      "areas" => {
        3 => {"id" => 3, "codes" => {"unit_id" => "43006"}, "name" => "Leyland South West", "type" => "CED"},
        4 => {"id" => 4, "codes" => {"unit_id" => "24783"}, "name" => "South Ribble", "type" => "WMC"}
      }
    }
    snac = LicenceLocationIdentifier.find_snac(geostack)

    assert_nil snac
  end

  should "return nil when a geostack does not provide any authorities" do
    geostack = {
      "areas" => {}
    }
    snac = LicenceLocationIdentifier.find_snac(geostack)

    assert_nil snac
  end
end
