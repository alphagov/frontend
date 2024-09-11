RSpec.describe "Developer Root" do
  context "when visiting /development" do
    it "includes a link to at least one example" do
      visit "/development"

      expect(page).to have_link("/", href: "/")
    end
  end
end
