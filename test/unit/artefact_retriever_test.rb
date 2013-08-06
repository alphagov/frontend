require 'test_helper'

class ArtefactRetrieverTest < ActiveSupport::TestCase
  class DummyStatsd
    def increment(*args); end
  end

  setup do
    @content_api = stub
    @retriever = ArtefactRetriever.new(@content_api, Rails.logger, DummyStatsd.new)
  end

  should "be able to fetch an artefact" do
    json_data = File.read(Rails.root.join('test/fixtures/foreign-travel-advice/index2.json'))
    index_artefact = GdsApi::Response.new(
      stub("HTTP_Response", :code => 200, :body => json_data),
      :web_urls_relative_to => "https://www.gov.uk"
    )
    @content_api.expects(:artefact).with('foreign-travel-advice', {}).returns(index_artefact)
    assert_nothing_raised do
      @retriever.fetch_artefact('foreign-travel-advice')
    end
  end

  should "raise a RecordNotFound if no artefact is returned" do
    assert_raises RecordNotFound do
      @content_api.expects(:artefact).with('beekeeping', {}).returns(nil)
      @retriever.fetch_artefact('beekeeping')
    end
  end

  should "raise an UnsupportedArtefactFormat exception if we get a bad format" do
    json_data = File.read(Rails.root.join('test/fixtures/jobsearch.json'))
    temp = JSON.parse(json_data)
    temp['format'] = 'something bad'
    tampered_json_data = JSON.dump(temp)

    index_artefact = GdsApi::Response.new(
      stub("HTTP_Response", :code => 200, :body => tampered_json_data),
      :web_urls_relative_to => "https://www.gov.uk"
    )

    assert_raises ArtefactRetriever::UnsupportedArtefactFormat do
      @content_api.expects(:artefact).with('jobsearch', {}).returns(index_artefact)
      @retriever.fetch_artefact('jobsearch')
    end
  end
end
