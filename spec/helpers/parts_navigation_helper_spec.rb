RSpec.describe PartsNavigationHelper do
  include PartsNavigationHelper

  let(:part_one) do
    {
      "slug" => "part-one",
      "title" => "Part one",
      "body" => "<p>This is part one</p>",
    }
  end

  let(:part_two) do
    {
      "slug" => "part-two",
      "title" => "Part two",
      "body" => "<p>This is part two</p>",
    }
  end

  describe "#previous_and_next_navigation" do
    it "gets the previous page and the next page when both are give" do
      expected_pages = {
        previous_page: {
          url: part_one["full_path"],
          title: I18n.t("multi_page.previous_page"),
          label: part_one["title"],
        },
        next_page: {
          url: part_two["full_path"],
          title: I18n.t("multi_page.next_page"),
          label: part_two["title"],
        },
      }
      expect(previous_and_next_navigation(part_one, part_two)).to eq(expected_pages)
    end

    it "gets the previous page when only the previous part is given" do
      expected_pages = {
        previous_page: {
          url: part_one["full_path"],
          title: I18n.t("multi_page.previous_page"),
          label: part_one["title"],
        },
      }
      expect(previous_and_next_navigation(part_one, nil)).to eq(expected_pages)
    end

    it "gets the next page when only the next part is given" do
      expected_pages = {
        next_page: {
          url: part_two["full_path"],
          title: I18n.t("multi_page.next_page"),
          label: part_two["title"],
        },
      }
      expect(previous_and_next_navigation(nil, part_two)).to eq(expected_pages)
    end
  end

  describe "part_link_elements" do
    let(:parts) { [part_one, part_two] }

    it "sets an active link on the cuurent part" do
      current_part = part_two
      expected_elements = [
        {
          href: part_one["full_path"],
          text: part_one["title"],
        },
        {
          href: part_two["full_path"],
          text: part_two["title"],
          active: true,
        },
      ]
      expect(part_link_elements(parts, current_part)).to eq(expected_elements)
    end
  end
end
