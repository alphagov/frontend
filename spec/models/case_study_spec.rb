RSpec.describe CaseStudy do
  it_behaves_like "it can be updated", "case_study"
  it_behaves_like "it can have metadata", "detailed_guide", "withdrawn_detailed_guide"
end
