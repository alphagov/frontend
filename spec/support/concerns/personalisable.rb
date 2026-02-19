RSpec.shared_examples "it supports personalisation cache headers" do
  it "sets GOVUK-Account-Session-Flash in the Vary header" do
    get base_path

    expect(response.headers["Vary"]).to include("GOVUK-Account-Session-Flash")
  end
end
