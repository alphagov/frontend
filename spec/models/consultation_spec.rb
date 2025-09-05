RSpec.describe Consultation do
  it_behaves_like "it can be withdrawn", "consultation", "consultation_withdrawn"
  it_behaves_like "it can have attachments", "consultation", "consultation_outcome_with_featured_attachments"
  it_behaves_like "it can have national applicability", "consultation", "consultation_outcome_with_featured_attachments"
end
