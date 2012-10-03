require 'test_helper'
require 'licence_location_identifier'

class LicenceLocationIdentifierTest < ActiveSupport::TestCase
  should "select the closest authority for a geostack providing county and district" do
    geostack = {
      "council" => [
        {"id" => 2230, "name" => "Lancashire County Council", "type" => "CTY", "ons" => "30"},
        {"id" => 2363, "name" => "South Ribble Borough Council", "type" => "DIS", "ons" => "30UN"}
      ]
    }
    snac = LicenceLocationIdentifier.find_snac(geostack)

    assert_equal "30UN", snac
  end

  should "select the closest authority for a geostack providing unitary authority" do
    geostack = {
      "council" => [
        {"id" => 1, "name" => "Shropshire Council", "type" => "UTA", "ons" => "00GG"},
        {"id" => 2, "name" => "Shrewsbury", "type" => "CPC" }
      ]
    }
    snac = LicenceLocationIdentifier.find_snac(geostack)

    assert_equal "00GG", snac
  end

  should "return nil when a geostack does not provide an appropriate authority" do
    geostack = {
      "council" => [
        {"id" => 1, "name" => "Leyland South West", "type" => "CED" },
        {"id" => 2, "name" => "South Ribble", "type" => "WMC" }
      ]
    }
    snac = LicenceLocationIdentifier.find_snac(geostack)

    assert_nil snac
  end

  should "return nil when a geostack does not provide any authorities" do
    geostack = {
      "council" => [ ]
    }
    snac = LicenceLocationIdentifier.find_snac(geostack)

    assert_nil snac
  end
end
