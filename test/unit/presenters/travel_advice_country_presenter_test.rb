require 'test_helper'

class TravelAdviceCountryPresenterTest < ActiveSupport::TestCase
  context "handling attachments" do
    context "an artefact with attachments" do
      setup do
        @json_data = File.read(Rails.root.join('test/fixtures/foreign-travel-advice/turks-and-caicos-islands.json'))
        @artefact = GdsApi::Response.new(stub("HTTP_Response", code: 200, body: @json_data))
        @presenter = TravelAdviceCountryPresenter.new(@artefact)
      end

      should "return image details wrapped in an Openstruct" do
        assert_equal @artefact["details"]["image"]["web_url"], @presenter.image.web_url
        assert_equal @artefact["details"]["image"]["content_type"], @presenter.image.content_type
      end

      should "return document details wrapped in an Openstruct" do
        assert_equal @artefact["details"]["document"]["web_url"], @presenter.document.web_url
        assert_equal @artefact["details"]["document"]["content_type"], @presenter.document.content_type
      end
    end

    context "an artefact without attachments" do
      setup do
        @json_data = File.read(Rails.root.join('test/fixtures/foreign-travel-advice/luxembourg.json'))
        @artefact = GdsApi::Response.new(stub("HTTP_Response", code: 200, body: @json_data))
        @presenter = TravelAdviceCountryPresenter.new(@artefact)
      end

      should "return nil for image" do
        assert_equal nil, @presenter.image
      end

      should "return nil for document" do
        assert_equal nil, @presenter.document
      end
    end
  end
end
