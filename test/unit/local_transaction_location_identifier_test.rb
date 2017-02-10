require 'test_helper'
require 'local_transaction_location_identifier'

class LocalTransactionLocationIdentifierTest < ActiveSupport::TestCase
  setup do
    @lancashire_county_council = {
      "name" => "Lancashire County Council",
      "type" => "CTY",
      "codes" => {
        "govuk_slug" => "lancashire-county-council",
      },
    }

    @south_ribble_borough_council = {
      "name" => "South Ribble Borough Council",
      "type" => "DIS",
      "codes" => {
        "govuk_slug" => "south-ribble-borough-council",
      },
    }

    @leyland_county_ward = {
      "name" => "Leyland South West",
      "type" => "CED",
    }

    @south_ribble_parliamentary_constituency = {
      "name" => "South Ribble",
      "type" => "WMC",
    }

    @shropshire_unitary_authority = {
      "name" => "Shropshire Council",
      "type" => "UTA",
      "codes" => {
        "govuk_slug" => "shropshire-council",
      },
    }

    @shrewsbury_civil_parish = {
      "name" => "Shrewsbury_civil_parish",
      "type" => "CPC",
    }
  end

  context "given an content item exists with a local service for the district/unitary tiers" do
    setup do
      @content_item = { "details" => { "service_tiers" => %w(district county) } }
    end

    should "select the correct tier authority from areas providing a district and county" do
      areas = [
        @lancashire_county_council,
        @south_ribble_borough_council,
        @leyland_county_ward,
        @south_ribble_parliamentary_constituency,
      ]
      slug = LocalTransactionLocationIdentifier.find_slug(areas, @content_item)

      assert_equal "south-ribble-borough-council", slug
    end

    should "return nil if no authorities match" do
      areas = [@leyland_county_ward, @south_ribble_parliamentary_constituency]
      slug = LocalTransactionLocationIdentifier.find_slug(areas, @content_item)

      assert_nil slug
    end
  end

  context "given an content item exists with a local service for the county/unitary tiers" do
    setup do
      @content_item = { "details" => { "service_tiers" => %w(county unitary) } }
    end

    should "select the correct tier authority from areas providing a district and county" do
      areas = [
        @lancashire_county_council,
        @south_ribble_borough_council,
        @leyland_county_ward,
        @south_ribble_parliamentary_constituency,
      ]
      slug = LocalTransactionLocationIdentifier.find_slug(areas, @content_item)

      assert_equal "lancashire-county-council", slug
    end

    should "select the correct tier authority from areas providing a unitary authority" do
      areas = [@shropshire_unitary_authority, @shrewsbury_civil_parish]
      slug = LocalTransactionLocationIdentifier.find_slug(areas, @content_item)

      assert_equal "shropshire-council", slug
    end
  end

  context "given an content item exists with a local service for all tiers" do
    setup do
      @content_item = { "details" => { "service_tiers" => %w(district unitary county) } }
    end

    should "select the correct tier authority from areas providing a district and county" do
      areas = [
        @lancashire_county_council,
        @south_ribble_borough_council,
        @leyland_county_ward,
        @south_ribble_parliamentary_constituency,
      ]
      slug = LocalTransactionLocationIdentifier.find_slug(areas, @content_item)

      assert_equal "south-ribble-borough-council", slug
    end
  end
end
