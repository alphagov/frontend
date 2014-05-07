require_relative '../../test_helper'
require 'ostruct'

class SpecialistSectorPresenterTest < ActiveSupport::TestCase
  context "a sector called Oil and gas" do
    setup do
      @sector = OpenStruct.new(title: "Oil and gas")
    end

    should "strip the sector title from the artefact title" do
      artefact = OpenStruct.new(title: "Oil and gas: Wells and fields")
      sector = SpecialistSectorPresenter.new(artefact, @sector)
      assert_equal "Wells and fields", sector.title
    end

    should "upcase the first character of the remaining part of the artefact title" do
      artefact = OpenStruct.new(title: "Oil and gas: taxes")
      sector = SpecialistSectorPresenter.new(artefact, @sector)
      assert_equal "Taxes", sector.title
    end

    should "leave a non-matching artefact title intact" do
      artefact = OpenStruct.new(title: "a page about something else")
      sector = SpecialistSectorPresenter.new(artefact, @sector)
      assert_equal "a page about something else", sector.title
    end

    should "only match the sector title at the beginning of the artefact title" do
      artefact = OpenStruct.new(title: "Also about Oil and Gas: Wells")
      sector = SpecialistSectorPresenter.new(artefact, @sector)
      assert_equal "Also about Oil and Gas: Wells", sector.title
    end
  end
end

