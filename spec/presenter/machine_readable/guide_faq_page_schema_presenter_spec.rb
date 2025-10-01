RSpec.describe MachineReadable::GuideFaqPageSchemaPresenter do
  subject(:presenter) { described_class.new(content_item, "https://example.com/logo.png") }

  let(:content_store_response) { GovukSchemas::Example.find("guide", example_name: "guide") }
  let(:content_item) { Guide.new(content_store_response) }

  describe "#structured_data" do
    it "has the correct type" do
      expect(presenter.structured_data["@type"]).to eq("FAQPage")
    end

    it "contains the headline" do
      expect(presenter.structured_data["headline"]).to eq("The national curriculum")
    end

    it "contains the part titles in the mainEntity" do
      q_and_as = presenter.structured_data["mainEntity"]

      chapter_titles = [
        "Overview",
        "Key stage 1 and 2",
        "Key stage 3 and 4",
        "Other compulsory subjects",
      ]

      expect(chapter_titles).to eq(q_and_as.map { |q_and_a| q_and_a["name"] })
    end

    it "has the correct part urls in the mainEntity and acceptedAnswer blocks" do
      q_and_as = presenter.structured_data["mainEntity"]
      answers = q_and_as.map { |q_and_a| q_and_a["acceptedAnswer"] }

      guide_part_urls = [
        "http://www.dev.gov.uk/national-curriculum",
        "http://www.dev.gov.uk/national-curriculum/key-stage-1-and-2",
        "http://www.dev.gov.uk/national-curriculum/key-stage-3-and-4",
        "http://www.dev.gov.uk/national-curriculum/other-compulsory-subjects",
      ]

      expect(guide_part_urls).to eq(q_and_as.map { |q_and_a| q_and_a["url"] })
      expect(guide_part_urls).to eq(answers.map { |answer| answer["url"] })
    end
  end
end
