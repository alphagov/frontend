RSpec.describe CaseStudy do
  it_behaves_like "it can be updated", "detailed_guide", "withdrawn_detailed_guide"
  it_behaves_like "it can have metadata", "detailed_guide", "withdrawn_detailed_guide"
  it_behaves_like "it can be linkable", "detailed_guide", "withdrawn_detailed_guide"
end
