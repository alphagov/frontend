RSpec.describe ManualUpdatesPresenter do
  subject(:presenter) { described_class.new(content_item) }

  let(:content_item) { Manual.new(content_store_response) }
  let(:content_store_response) { GovukSchemas::Example.find("manual", example_name: "content-design") }

  it_behaves_like "it can have manual metadata", Manual

  describe "#presented_change_notes" do
    let(:change_notes) { content_item.change_notes }
    let(:first_note) { change_notes[0] }
    let(:second_note) { change_notes[1] }
    let(:third_note) { change_notes[2] }
    let(:fourth_note) { change_notes[3] }

    let(:expected_grouped_changes_notes) do
      [
        [
          2014,
          [
            [
              "6 October 2014 <span class=\"govuk-visually-hidden\">#{I18n.t('formats.manuals.updates_amendments')}</span>",
              {
                first_note["base_path"].to_s => [first_note],
                second_note["base_path"].to_s => [second_note],
                third_note["base_path"].to_s => [third_note],
              },
            ],
          ],
        ],
        [
          2013,
          [
            [
              "6 October 2013 <span class=\"govuk-visually-hidden\">#{I18n.t('formats.manuals.updates_amendments')}</span>",
              {
                fourth_note["base_path"].to_s => [fourth_note],
              },
            ],
          ],
        ],
      ]
    end

    it "returns grouped change notes" do
      expect(presenter.presented_change_notes)
        .to eq(expected_grouped_changes_notes)
    end
  end

  describe "#sanitize_manual_update_title" do
    context "when title is empty" do
      it "returns an empty string" do
        expect(presenter.sanitize_manual_update_title(""))
          .to eq("")
      end
    end

    context "when title is nil" do
      it "returns an empty string" do
        expect(presenter.sanitize_manual_update_title(nil))
          .to eq("")
      end
    end

    context "when title contains html" do
      it "removes HTML from the title" do
        expect(presenter.sanitize_manual_update_title("<h1> Hello world </h1>"))
          .to eq("Hello world")
      end
    end

    context "when title has translation elements" do
      it "removes the manuals.updates_amendments string from the title" do
        actual = " <h1> Hello world </h1> <span> #{I18n.t('formats.manuals.updates_amendments')} </span> "
        expect(presenter.sanitize_manual_update_title(actual))
          .to eq("Hello world")
      end

      it "only removes the unrequired elements from the title" do
        actual = " <h1> Hello world </h1> <span> ABC #{I18n.t('formats.manuals.updates_amendments')} XYZ </span> "
        expect(presenter.sanitize_manual_update_title(actual))
          .to eq("Hello world ABC XYZ")
      end
    end
  end
end
