RSpec.describe "StatisticsAnnouncement" do
  context "when visiting an official statistics announcement page" do
    let(:content_store_response) { GovukSchemas::Example.find("statistics_announcement", example_name: "official_statistics") }
    let(:base_path) { content_store_response.fetch("base_path") }
    
    before do
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path
    end
    
    it "displays the title" do
      expect(page).to have_title("Diagnostic imaging dataset for September 2015")
      expect(page).to have_css("h1.gem-c-heading__text", text: content_store_response["title"])
    end

    it "displays the description" do
      expect(page).to have_text(content_store_response.dig("details", "description"))
    end

    it "displays the important metadata" do
      within(".important-metadata .gem-c-metadata") do
        expect(page).to have_content("20 January 2016 9:30am (confirmed)")
      end
    end

    it "display forthcoming notice" do
      within(".gem-c-notice") do
        expect(page).to have_text("These statistics will be released on #{content_store_response.dig("details", "display_date")}")
      end
    end

    it "does not render with the single page notification button" do
      expect(page).not_to have_css(".gem-c-single-page-notification-button")
    end
  end

  context "when visiting a national statistics announcement page" do
    let(:content_store_response) { GovukSchemas::Example.find("statistics_announcement", example_name: "national_statistics") }
    let(:base_path) { content_store_response.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path
    end

    it "displays the title" do
      expect(page).to have_title("UK armed forces quarterly personnel report: 1 October 2015")
      expect(page).to have_css("h1.gem-c-heading__text", text: content_store_response["title"])
    end

    it "shows a logo" do
      expect(page).to have_selector('img[alt="Accredited official statistics"]')
    end

    it "displays the description" do
      expect(page).to have_text(content_store_response.dig("details", "description"))
    end

    it "displays the important metadata" do
      within(".important-metadata .gem-c-metadata") do
        expect(page).to have_content("Release date: January 2016 (provisional)")
      end
    end
  end

  context "when visiting a cancelled statistics announcement page" do
    let(:content_store_response) { GovukSchemas::Example.find("statistics_announcement", example_name: "cancelled_official_statistics") }
    let(:base_path) { content_store_response.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path
    end

    it "displays the title" do
      expect(page).to have_title("Diagnostic imaging dataset for September 2015")
      expect(page).to have_css("h1.gem-c-heading__text", text: content_store_response["title"])
    end

    it "displays the description" do
      expect(page).to have_text(content_store_response.dig("details", "description"))
    end

    it "displays the important metadata" do
      within(".important-metadata .gem-c-metadata") do
        expect(page).to have_content("Proposed release: 20 January 2016 9:30am")
        expect(page).to have_content("Cancellation date: 17 January 2016 2:19pm")
      end
    end

    it "displays the cancellation notice" do
      within(".gem-c-notice") do
        expect(page).to have_text("Statistics release cancelled")
        expect(page).to have_text(content_store_response.dig("details", "canellation_reason"))
      end
    end

    it "doesn't display forthcoming notice" do
      within(".gem-c-notice") do
        expect(page).not_to have_text("These statistics will be released on")
      end
    end
  end

  context "when visiting a statistics announcement page with a release date changed" do
    let(:content_store_response) { GovukSchemas::Example.find("statistics_announcement", example_name: "release_date_changed") }
    let(:base_path) { content_store_response.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path
    end

    it "displays the title" do
      expect(page).to have_title("Diagnostic imaging dataset for September 2015")
      expect(page).to have_css("h1.gem-c-heading__text", text: content_store_response["title"])
    end

    it "displays the description" do
      expect(page).to have_text(content_store_response.dig("details", "description"))
    end

    it "displays the important metadata" do
      within(".important-metadata .gem-c-metadata") do
        expect(page).to have_content("Release date: 20 January 2016 9:30am (confirmed")
      end
    end

    it "displays the release date change details" do
      within(".release-date-changed .gem-c-metadata") do
        expect(page).to have_text("The release date has been changed")
        expect(page).to have_text("Previous date")
        expect(page).to have_text("19 January 2016 9:30am")
        expect(page).to have_text("Reason for change")
        expect(page).to have_text(content_store_response.dig("details", "latest_change_note"))

      end
    end
  end
end
