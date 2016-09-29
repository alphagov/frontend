require 'test_helper'
require "ostruct"

class CampaignHelperTest < ActionView::TestCase
  include CampaignHelper

  setup do
    @model = PublicationPresenter.new(JSON.parse(
                                        File.read(
                                          Rails.root.join("test/fixtures/britain-is-great.json")
                                        )
    ))
  end

  test "campaign_image_url" do
    assert_equal "http://www.example.com/media/52380a1e686c82231f000003/britain-is-great.jpg",
      campaign_image_url(@model, 'large')
    assert_equal "http://www.example.com/media/52380a1e686c82231f000005/britain-is-great.jpg",
      campaign_image_url(@model, 'medium')
    assert_equal "http://www.example.com/media/52383e4b686c82308d000001/britain-is-great.jpg",
      campaign_image_url(@model, 'small')
  end

  test "formatted_organisation_name" do
    assert_equal "Department for <br/>Transport", formatted_organisation_name(@model)
  end

  test "organisation_url" do
    assert_equal "http://www.example.com/government/organisations/cabinet-office", organisation_url(@model)
  end

  test "organisation_crest" do
    assert_equal "single-identity", organisation_crest(@model)
  end

  test "organisation_brand_colour" do
    assert_equal "cabinet-office", organisation_brand_colour(@model)
  end

  context "has_organisation?" do
    context "when publication does not have organisation details" do
      setup do
        @publication = OpenStruct.new(details: {})
      end

      should "return false" do
        assert_equal false, has_organisation?(@publication)
      end
    end

    context "when publication has organisation details with values" do
      setup do
        @publication = OpenStruct.new(
          details: {
            "organisation" => {
              "formatted_name" => "Department for \nTransport",
              "url" => "http://www.example.com/government/organisations/cabinet-office",
              "brand_colour" => "cabinet-office",
              "crest" => "single-identity",
            }
          }
        )
      end

      should "return true" do
        assert_equal true, has_organisation?(@publication)
      end
    end

    context "when publication has organisation details without values" do
      setup do
        @publication = OpenStruct.new(
          details: {
            "organisation" => {
              "formatted_name" => "",
              "url" => "",
              "brand_colour" => "",
              "crest" => "",
            }
          }
        )
      end

      should "return false" do
        assert_equal false, has_organisation?(@publication)
      end
    end
  end
end
