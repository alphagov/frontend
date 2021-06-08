require "test_helper"
require "local_authority_slug_finder"

class LocalAuthoritySlugFinderTest < ActiveSupport::TestCase
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

    @aylesbury_district_without_slug = {
      "name" => "Aylesbury District",
      "type" => "DIS",
    }

    @shropshire_unitary_authority = {
      "name" => "Shropshire Council",
      "type" => "UTA",
      "codes" => {
        "govuk_slug" => "shropshire-council",
      },
    }

    @belfast_council = {
      "name" => "Belfast Council",
      "type" => "LGD",
      "codes" => {
        "govuk_slug" => "belfast-council",
      },
    }

    @sunderland_council = {
      "name" => "Sunderland Council",
      "type" => "MTD",
      "codes" => {
        "govuk_slug" => "sunderland-council",
      },
    }

    @scilly_council = {
      "name" => "Scilly Council",
      "type" => "COI",
      "codes" => {
        "govuk_slug" => "scilly-council",
      },
    }

    @islington_council = {
      "name" => "Islington Council",
      "type" => "LBO",
      "codes" => {
        "govuk_slug" => "islington-council",
      },
    }

    @south_ribble_parliamentary_constituency = {
      "name" => "South Ribble",
      "type" => "WMC",
    }

    @shrewsbury_civil_parish = {
      "name" => "Shrewsbury_civil_parish",
      "type" => "CPC",
    }

    @leyland_county_ward = {
      "name" => "Leyland South West",
      "type" => "CED",
    }
  end

  context "for single tier lookup" do
    context "for London Borough (LBO)" do
      should "return the slug of the London Borough" do
        areas = [@islington_council]

        slug = LocalAuthoritySlugFinder.call(areas)
        assert_equal "islington-council", slug
      end
    end

    context "for Unitary Authority (UTA)" do
      should "return the slug of the Unitary Authority" do
        areas = [@shropshire_unitary_authority]

        slug = LocalAuthoritySlugFinder.call(areas)
        assert_equal "shropshire-council", slug
      end
    end

    context "for Northern Ireland Council (LGD)" do
      should "return the slug of the Northern Ireland Council" do
        areas = [@belfast_council]

        slug = LocalAuthoritySlugFinder.call(areas)
        assert_equal "belfast-council", slug
      end
    end

    context "for Metropolitan District (MTD)" do
      should "return the slug of the Metropolitan District" do
        areas = [@sunderland_council]

        slug = LocalAuthoritySlugFinder.call(areas)
        assert_equal "sunderland-council", slug
      end
    end

    context "for Isles of Scilly (COI)" do
      should "return the slug of the Isles of Scilly Council" do
        areas = [@scilly_council]

        slug = LocalAuthoritySlugFinder.call(areas)
        assert_equal "scilly-council", slug
      end
    end

    context "with other area type look ups" do
      context "with valid area present" do
        should "ignore other area types and return valid area slug" do
          areas = [@south_ribble_borough_council, @south_ribble_parliamentary_constituency]

          slug = LocalAuthoritySlugFinder.call(areas)
          assert_equal "south-ribble-borough-council", slug
        end
      end

      context "with only invalid areas present" do
        should "return nil" do
          areas = [@shrewsbury_civil_parish, @south_ribble_parliamentary_constituency]

          slug = LocalAuthoritySlugFinder.call(areas)
          assert_nil slug
        end
      end
    end
  end

  context "for district (DIS)/county (CTY) tier lookup" do
    setup do
      @areas = [
        @south_ribble_borough_council,
        @lancashire_county_council,
      ]
    end

    should "return District slug by default" do
      slug = LocalAuthoritySlugFinder.call(@areas)
      assert_equal "south-ribble-borough-council", slug
    end

    should "return County slug if requested" do
      slug = LocalAuthoritySlugFinder.call(@areas, county_requested: true)
      assert_equal "lancashire-county-council", slug
    end
  end

  context "with areas missing govuk_slug" do
    should "return nil" do
      @areas = [@aylesbury_district_without_slug]

      slug = LocalAuthoritySlugFinder.call(@areas)
      assert_nil slug
    end
  end

  context "with no areas present" do
    should "return nil" do
      slug = LocalAuthoritySlugFinder.call([])
      assert_nil slug
    end
  end
end
