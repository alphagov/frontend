RSpec.describe DocumentCollection do
  it_behaves_like "it has historical government information", "document_collection", "document_collection_political"
  it_behaves_like "it has updates", "document_collection", "document_collection_with_history"
  it_behaves_like "it has no updates", "document_collection", "document_collection"
  it_behaves_like "it can be withdrawn", "document_collection", "document_collection_withdrawn"
end
