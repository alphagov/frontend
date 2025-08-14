RSpec.describe Calendar do
  include CalendarHelpers

  before do
    mock_calendar_fixtures
  end

  context "when finding a calendar by slug" do
    it "constructs a calendar with the slug and data from the corresponding JSON file" do
      data_from_json = JSON.parse(File.read(Rails.root.join(Calendar::REPOSITORY_PATH, "single-calendar.json")))
      allow(described_class).to receive(:new).with("single-calendar", data_from_json).and_return(:a_calendar)
      cal = described_class.find("single-calendar")

      expect(cal).to eq(:a_calendar)
    end

    it "raises exception when calendar doesn't exist" do
      expect { described_class.find("non-existent") }.to raise_error(Calendar::CalendarNotFound)
    end
  end

  it "returns the slug" do
    expect(described_class.new("a-slug", {}).slug).to eq("a-slug")
  end

  it "returns the slug for to_param" do
    expect(described_class.new("a-slug", {}).to_param).to eq("a-slug")
  end

  it "returns the parsed last_updated value as a date" do
    expect(described_class.new("a-slug", { "last_updated" => "12/12/2025" }).last_updated).to eq(Date.new(2025, 12, 12))
  end

  it "returns an empty last_updated value as today's date" do
    expect(described_class.new("a-slug", {}).last_updated).to eq(Time.zone.today)
  end

  describe "#divisions" do
    subject(:calendar) do
      described_class.new(
        "a-calendar",
        "title" => "UK bank holidays",
        "divisions" => {
          "common.nations.england-and-wales_slug" => { "2012" => [1], "2013" => [3] },
          "common.nations.scotland_slug" => { "2012" => [1, 2], "2013" => [3, 4] },
          "common.nations.northern-ireland_slug" => { "2012" => [2], "2013" => [4] },
        },
      )
    end

    it "constructs a division for each one in the data" do
      allow(Calendar::Division).to receive(:new).with("england-and-wales", { "2012" => [1], "2013" => [3] }).and_return(:england_and_wales)
      allow(Calendar::Division).to receive(:new).with("scotland", { "2012" => [1, 2], "2013" => [3, 4] }).and_return(:scotland)
      allow(Calendar::Division).to receive(:new).with("northern-ireland", { "2012" => [2], "2013" => [4] }).and_return(:northern_ireland)

      expect(calendar.divisions).to eq(%i[england_and_wales scotland northern_ireland])
    end

    it "caches the constructed instances" do
      first = calendar.divisions

      expect(Calendar::Division).not_to receive(:new)
      expect(calendar.divisions).to eq(first)
    end

    context "when finding a division by slug" do
      it "returns the division with the matching slug" do
        div = calendar.division("england-and-wales")

        expect(div.class).to eq(Calendar::Division)
        expect(div.title).to eq("England and wales")
      end

      it "raises exception when division doesn't exist" do
        expect { calendar.division("non-existent") }.to raise_error(Calendar::CalendarNotFound)
      end
    end
  end

  describe "#events" do
    subject(:calendar) { described_class.new("a-calendar") }

    let(:divisions) { [] }

    before do
      allow(calendar).to receive(:divisions).and_return(divisions) # rubocop:disable RSpec/SubjectStub
    end

    it "merges events for all years into single array" do
      divisions << instance_double(Calendar::Division, events: [1, 2])
      divisions << instance_double(Calendar::Division, events: [3, 4, 5])
      divisions << instance_double(Calendar::Division, events: [6, 7])

      expect(calendar.events).to eq([1, 2, 3, 4, 5, 6, 7])
    end

    it "handles years with no events" do
      divisions << instance_double(Calendar::Division, events: [1, 2])
      divisions << instance_double(Calendar::Division, events: [])
      divisions << instance_double(Calendar::Division, events: [6, 7])

      expect(calendar.events).to eq([1, 2, 6, 7])
    end
  end

  describe "attribute accessors" do
    subject(:calendar) { described_class.new("a-calendar", "title" => "bank_holidays.calendar.title", "description" => "bank_holidays.calendar.description") }

    it "has an accessor for the title" do
      expect(calendar.title).to eq("UK bank holidays")
    end

    it "has an accessor for the description" do
      expect(calendar.description).to eq("Find out when bank holidays are in England, Wales, Scotland and Northern Ireland - including past and future bank holidays")
    end
  end

  describe "#show_bunting?" do
    subject(:calendar) { described_class.new("a-calendar") }

    it "is true when one division is buntable" do
      div1 = instance_double(Calendar::Division, show_bunting?: true)
      div2 = instance_double(Calendar::Division, show_bunting?: false)
      div3 = instance_double(Calendar::Division, show_bunting?: false)
      allow(calendar).to receive(:divisions).and_return([div1, div2, div3]) # rubocop:disable RSpec/SubjectStub

      expect(calendar.show_bunting?).to be true
    end

    it "is true when more than one division is buntable" do
      div1 = instance_double(Calendar::Division, show_bunting?: true)
      div2 = instance_double(Calendar::Division, show_bunting?: true)
      div3 = instance_double(Calendar::Division, show_bunting?: false)
      allow(calendar).to receive(:divisions).and_return([div1, div2, div3]) # rubocop:disable RSpec/SubjectStub

      expect(calendar.show_bunting?).to be true
    end

    it "is false when no divisions are buntable" do
      div1 = instance_double(Calendar::Division, show_bunting?: false)
      div2 = instance_double(Calendar::Division, show_bunting?: false)
      div3 = instance_double(Calendar::Division, show_bunting?: false)
      allow(calendar).to receive(:divisions).and_return([div1, div2, div3]) # rubocop:disable RSpec/SubjectStub

      expect(calendar.show_bunting?).to be false
    end
  end

  describe "#as_json" do
    subject(:calendar) { described_class.new("a-calendar") }

    before do
      div1 = instance_double(Calendar::Division, slug: "division-1", as_json: "div1 json")
      div2 = instance_double(Calendar::Division, slug: "division-2", as_json: "div2 json")
      allow(calendar).to receive(:divisions).and_return([div1, div2]) # rubocop:disable RSpec/SubjectStub
    end

    it "construct a hash representation of all divisions" do
      expected = { "division-1" => "div1 json", "division-2" => "div2 json" }

      expect(calendar.as_json).to eq(expected)
    end
  end
end
