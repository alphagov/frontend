require 'test_helper'

class ContentFormatInspectorTest < ActiveSupport::TestCase
  def subject
    @_s ||= ContentFormatInspector.new(:slug)
  end

  context "document isn't found in the content-store" do
    setup do
      stub_content_store
    end

    should "return the format of the artefact from content_api" do
      set_artefact_format("foo")
      assert subject.format == "foo"
    end
  end

  context "format hasn't been migrated to the content-store" do
    setup do
      set_content_item_format("bar")
    end

    should "return the format of the artefact from content_api" do
      set_artefact_format("foo")
      assert subject.format == "foo"
    end
  end

  context "draft content requested" do
    should "return the format of the artefact from content-api" do
      set_artefact_format("foo")
      assert ContentFormatInspector.new(:slug, :edition).format == "foo"
    end
  end

  context "format has been migrated to the content-store" do
    setup do
      set_content_item_format("help_page")
    end

    should "return the format of the content item from the content-store" do
      assert subject.format == "help_page"
    end
  end

  context "content-store lookup throws an error" do
    setup do
      @error = GdsApi::HTTPNotFound.new("asd")
      stub_content_store_raises(@error)
    end

    context "#format" do
      should "return nil" do
        assert_nil subject.format
      end
    end

    context "#error" do
      should "return the error" do
        subject.format
        assert subject.error == @error
      end
    end
  end

  context "content_api lookup throws an error" do
    setup do
      @error = GdsApi::HTTPErrorResponse.new("asd")
      stub_content_store
      stub_content_api_raises(@error)
    end

    context "#format" do
      should "return nil" do
        assert_nil subject.format
      end
    end

    context "#error" do
      should "return the error" do
        subject.format
        assert subject.error == @error
      end
    end
  end

  def stub_content_api_raises(error)
    ArtefactRetrieverFactory.expects(:artefact_retriever).raises(error)
  end

  def stub_content_store_raises(error)
    Services.expects(:content_store).raises(error)
  end

  def set_content_item_format(format)
    @content_item = {'schema_name' => format}
    stub_content_store
  end

  def set_artefact_format(format)
    @artefact = {'format' => format}
    stub_content_api
  end

  def stub_content_store
    content_store = stub
    content_store.expects(:content_item).returns(@content_item || {})
    Services.expects(:content_store).returns(content_store)
  end

  def stub_content_api
    artefact_retriever = stub
    artefact_retriever.expects(:fetch_artefact).returns(@artefact || {})
    ArtefactRetrieverFactory.expects(:artefact_retriever).returns(artefact_retriever)
  end
end
