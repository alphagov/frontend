RSpec.describe "Service Manual guide" do
  describe "GET /<document_type>/<slug>" do
    let(:content_store_response) { GovukSchemas::Example.find("service_manual_guide", example_name: "service_manual_guide") }
    let(:base_path) { content_store_response.fetch("base_path") }

    describe "with default content_store_response state" do
      before do
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path
      end

      it "displays the page" do
        expect(page.status_code).to eq(200)
      end

      it "shows the time it was published if it has been published" do
        travel_to Time.zone.local(2015, 10, 10, 0, 0, 0) do
          visit base_path

          within(".app-change-history") do
            expect(page).to have_text("about 15 hours ago")
          end
        end
      end

      it "service manual guide shows content owners" do
        within(".app-metadata--heading") do
          expect(page).to have_link("Agile delivery community")
        end
      end

      it "the breadcrumb contains the topic" do
        within(".gem-c-breadcrumbs") do
          expect(page).to have_link("Service manual")
          expect(page).to have_link("Agile")
        end
      end

      it "does not display the description for a normal guide" do
        expect(page).not_to have_css(".app-page-header__summary")
      end

      it "displays a link to give feedback" do
        expect(page).to have_link("Give feedback about this page")
      end

      it "displays the published date of the most recent change" do
        within(".app-change-history") do
          expect { page.has_text?("Last update:\n9 October 2015") }.not_to raise_error
        end
      end

      it "displays the most recent change history for a guide" do
        within(".app-change-history") do
          expect(page).to have_content("This is our latest change")
        end
      end

      it "displays the change history for a guide" do
        within(".app-change-history__past") do
          expect(page).to have_content("This is another change")
          expect(page).to have_content("Guidance first published")
        end
      end
    end

    describe "with non-default content_store_response state" do
      it "shows the time it was saved if it hasn't been published yet" do
        now = "2015-10-10T09:00:00+00:00"
        last_saved_at = "2015-10-10T08:55:00+00:00"

        travel_to(now) do
          content_store_response["public_updated_at"] = nil
          content_store_response["updated_at"] = last_saved_at
          stub_content_store_has_item(base_path, content_store_response)
          visit base_path

          within(".app-change-history") do
            expect(page).to have_text("5 minutes ago")
          end
        end
      end

      it "service manual guide does not show published by" do
        content_store_response = GovukSchemas::Example.find("service_manual_guide", example_name: "service_manual_guide_community")
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path

        within(".gem-c-metadata") do
          expect(page).not_to have_content("Published by")
        end
      end

      it "displays the description for a point" do
        content_store_response = GovukSchemas::Example.find("service_manual_guide", example_name: "point_page")
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path

        within(".app-page-header__summary") do
          expect(page).to have_content("Research to develop a deep knowledge of who the service users are")
        end
      end

      it "omits the previous history if there is only one change" do
        content_store_response["details"]["change_history"] = [
          {
            "public_timestamp" => "2015-09-01T08:17:10+00:00",
            "note" => "Guidance first published",
          },
        ]
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path

        expect(page).not_to have_content("Show all page updates")
        expect(page).not_to have_css(".app-change-history__past")
      end

      it "omits the latest change and previous change if the guide has no history" do
        content_store_response["details"]["change_history"] = []
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path

        expect(page).not_to have_content("Last update:")
        expect(page).not_to have_content("Show all page updates")
        expect(page).not_to have_css(".app-change-history__past")
      end
    end
  end
end
