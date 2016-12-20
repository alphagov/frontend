require 'test_helper'
require 'artefact_retriever_with_request_cache'

class ArtefactRetrieverWithRequestCacheTest < ActiveSupport::TestCase
  setup do
    @mock = mock
    @env = {}
    @artefact = :artefact
    @request = stub(env: @env)
    @subject = ArtefactRetrieverWithRequestCache.new(artefact_retriever: @mock)
    @subject.set_request(@request)
  end

  context "#fetch_artefact" do
    should "raise a RequestMissingException unless the request has been set" do
      assert_raises RequestMissingException do
        ArtefactRetrieverWithRequestCache
          .new(artefact_retriever: @mock)
          .fetch_artefact(@slug)
      end
    end

    should "proxy a request to the content API" do
      @mock.expects(:fetch_artefact).returns(@artefact)
      result = @subject.fetch_artefact('foo')
      assert_equal result, @artefact
    end

    should "cache the result of the call to content API" do
      @mock.expects(:fetch_artefact).returns(@artefact).once
      @subject.fetch_artefact('foo')
      @subject.fetch_artefact('foo')
    end

    should "cache-miss if the slug changes" do
      @mock.expects(:fetch_artefact).returns(@artefact).twice
      @subject.fetch_artefact('foo')
      @subject.fetch_artefact('bar')
    end

    should "return false if the content API throws an error" do
      @mock.expects(:fetch_artefact).raises(RuntimeError)
      result = @subject.fetch_artefact('foo')
      assert_equal false, result
    end

    should "cache the error if the content API throws an error" do
      @mock.expects(:fetch_artefact).raises(RuntimeError).once
      @subject.fetch_artefact('foo')
      @subject.fetch_artefact('foo')
    end

    should "return false on subsequent calls after an error has been caught" do
      @mock.expects(:fetch_artefact).raises(RuntimeError)
      @subject.fetch_artefact('foo')
      result = @subject.fetch_artefact('bar')
      assert_equal false, result
    end
  end

  context "#error?" do
    should "return true if it has previously seen an error in the content API response" do
      @mock.expects(:fetch_artefact).raises(RuntimeError)
      @subject.fetch_artefact('foo')
      assert @subject.error?
    end

    should "return false if there has been no error" do
      @mock.expects(:fetch_artefact).returns(@artefact)
      @subject.fetch_artefact('foo')
      assert_equal false, @subject.error?
    end
  end

  context "#error" do
    should "return the cached error" do
      error = RuntimeError.new
      @mock.expects(:fetch_artefact).raises(error)
      @subject.fetch_artefact('foo')
      assert_equal error, @subject.error
    end

    should "return nil if there is no error" do
      @mock.expects(:fetch_artefact).returns(@artefact)
      @subject.fetch_artefact('foo')
      assert_nil @subject.error
    end
  end
end
