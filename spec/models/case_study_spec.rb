RSpec.describe CaseStudy do
  it_behaves_like "it has updates", "case_study", "doing-business-in-spain"
  it_behaves_like "it can have worldwide organisations", "case_study", "doing-business-in-spain"
  it_behaves_like "it can have emphasised organisations", "case_study", "doing-business-in-spain"
end
