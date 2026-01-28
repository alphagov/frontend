RSpec.describe ManualSection do
  include ContentStoreHelpers

  before do
    manual_content_item = GovukSchemas::Example.find("manual", example_name: "content-design")
    stub_content_store_has_item(manual_content_item.fetch("base_path"), manual_content_item)
  end

  it_behaves_like "it can have manual title", "manual_section", "what-is-content-design"
  it_behaves_like "it can have document heading", "manual_section", "what-is-content-design"
  it_behaves_like "it can have breadcrumbs", "manual_section", "what-is-content-design"
  it_behaves_like "it can have breadcrumb", "manual_section", "what-is-content-design"
  it_behaves_like "it can have manual base path", "manual_section", "what-is-content-design"
  it_behaves_like "it checks for hmrc", "manual_section", "what-is-content-design"
  it_behaves_like "it can have section groups", "manual", "content-design"
end
