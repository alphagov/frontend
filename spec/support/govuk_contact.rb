RSpec.shared_examples_for "a GOV.UK contact" do
  context "on GET" do
    it "returns http success" do
      get :new
      expect(response).to be_successful
    end

    it "should return 406 when text/html isn't acceptable" do
      get :new, format: "nothing"

      expect(response.code).to eq("406")
    end
  end

  context "on POST" do
    it "should return 406 when text/html isn't acceptable" do
      stub_request(:any, /.*/)

      post :create, params: valid_params, format: "nothing"

      expect(response.code).to eq("406")
    end
  end
end
