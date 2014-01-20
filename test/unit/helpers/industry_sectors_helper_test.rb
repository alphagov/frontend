require 'test_helper'
require 'ostruct'

class IndustrySectorsHelperTest < ActiveSupport::TestCase
  include IndustrySectorsHelper

  context "industry_sector_item_title" do
    setup do
      @sector = OpenStruct.new(title: "Oil and gas")
    end

    should "strip the sector title from the provided string" do
      assert_equal "Wells and fields", industry_sector_item_title("Oil and gas: Wells and fields", @sector)
    end

    should "upcase the first character of the remaining part of the string" do
      assert_equal "Taxes", industry_sector_item_title("Oil and gas: taxes", @sector)
    end

    should "leave a non-matching string intact" do
      assert_equal "a page about something else", industry_sector_item_title("a page about something else", @sector)
    end

    should "only match the sector title at the beginning of the string" do
      assert_equal "Also about Oil and Gas: Wells", industry_sector_item_title("Also about Oil and Gas: Wells", @sector)
    end
  end
end
