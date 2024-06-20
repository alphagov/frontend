require "gds_zendesk/test_helpers"

RSpec.describe Contact::GovukController, type: :controller do
  include GDSZendesk::TestHelpers

  render_views

  let(:valid_params) do
    zendesk_has_user(email: "test@test.com", suspended: false)

    {
      contact: {
        name: "Joe Bloggs",
        email: "test@test.com",
        location: "all",
        textdetails: "Testing, testing, 1, 2, 3...",
      },
    }
  end

  it_behaves_like "a GOV.UK contact"

  context "with a valid contact submission" do
    it "should pass the contact onto the support app" do
      self.valid_zendesk_credentials = ZENDESK_CREDENTIALS
      stub_post = stub_zendesk_ticket_creation

      post :create, params: valid_params

      expect(response).to be_redirect
      expect(stub_post).to have_been_made
    end
  end
end
