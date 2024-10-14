RSpec.describe ContentsListHelper do
  include ContentsListHelper

  describe "#contents_list" do
    let(:current_path) { "/active-page" }

    it "returns a list of links" do
      links = [{
        "href" => "/landing-page",
        "text" => "Landing page",
      }]

      expected = [{
        href: "/landing-page",
        text: "Landing page",
      }]

      expect(contents_list(current_path, links)).to eq(expected)
    end

    it "sets a link to active if it matches the current path" do
      links = [{
        "href" => "/active-page",
        "text" => "Active page",
      }]

      expected = [{
        href: "/active-page",
        text: "Active page",
        active: true,
      }]

      expect(contents_list(current_path, links)).to eq(expected)
    end
  end
end
