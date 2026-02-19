RSpec.describe ContentItemsController do
  let(:content_item) { GovukSchemas::Example.find(:case_study, example_name: :case_study) }
  let(:base_path) { content_item["base_path"] }

  before { stub_content_store_has_item(base_path, content_item) }

  it_behaves_like "it supports personalisation cache headers"
end
