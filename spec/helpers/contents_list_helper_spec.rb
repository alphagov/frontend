RSpec.describe ContentsListHelper do
  include described_class

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

    context "when there are nested links" do
      it "returns a list of nested links" do
        links = [
          {
            "href" => "/landing-page",
            "text" => "Landing page",
          },
          {
            "href" => "/our-lorem",
            "text" => "Our Lorem",
            "links" => [
              {
                "href" => "/a",
                "text" => "Child 1",
              },
              {
                "href" => "/b",
                "text" => "Child 2",
              },
            ],
          },
        ]

        expected = [
          {
            href: "/landing-page",
            text: "Landing page",
          },
          {
            href: "/our-lorem",
            text: "Our Lorem",
            links: [
              {
                href: "/a",
                text: "Child 1",
              },
              {
                href: "/b",
                text: "Child 2",
              },
            ],
          },
        ]

        expect(contents_list(current_path, links)).to eq(expected)
      end

      it "sets nested link to active if it matches the current path" do
        links = [
          {
            "href" => "/landing-page",
            "text" => "Landing page",
          },
          {
            "href" => "/our-lorem",
            "text" => "Our Lorem",
            "links" => [
              {
                "href" => "/a",
                "text" => "Child 1",
              },
              {
                "href" => "/active-page",
                "text" => "Active page",
              },
            ],
          },
        ]

        expected = [
          {
            href: "/landing-page",
            text: "Landing page",
          },
          {
            href: "/our-lorem",
            text: "Our Lorem",
            links: [
              {
                href: "/a",
                text: "Child 1",
              },
              {
                href: "/active-page",
                text: "Active page",
                active: true,
              },
            ],
          },
        ]

        expect(contents_list(current_path, links)).to eq(expected)
      end
    end
  end
end
