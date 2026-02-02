RSpec.describe ManualSection do
  it_behaves_like "it can have manual title", "manual_section", "what-is-content-design"
  it_behaves_like "it can have page title", "manual_section", "what-is-content-design"
  it_behaves_like "it can have document heading", "manual_section", "what-is-content-design"
  it_behaves_like "it can have breadcrumbs", "manual_section", "what-is-content-design"
  it_behaves_like "it can have manual base path", "manual_section", "what-is-content-design"
  it_behaves_like "it can have section groups", "manual", "content-design"
end
