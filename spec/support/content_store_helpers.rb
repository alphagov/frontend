require "gds_api/test_helpers/content_store"

module ContentStoreHelpers
  include GdsApi::TestHelpers::ContentStore

  def content_store_throws_exception_for(path, exception)
    content_store = double
    allow(content_store).to receive(:content_item).with(path).and_raise(exception)
    allow(GdsApi).to receive(:content_store).and_return(content_store)
  end
end
