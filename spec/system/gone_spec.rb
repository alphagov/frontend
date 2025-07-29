RSpec.describe "Gone page" do
  describe "GET /<document_type>/<slug>" do
    let(:content_store_response) { GovukSchemas::Example.find("gone", example_name: "gone") }
    let(:base_path) { content_store_response.fetch("base_path") }

    context "when there are is an explanation" do
      before do
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path
      end

      it "displays the page" do
        expect(page.status_code).to eq(200)
      end

      it "has the correct title" do
        expect(page.title).to eq("GOV.UK")
      end

      it "has the correct heading" do
        within("h1") do
          expect(page).to have_text("The page you're looking for is no longer available")
        end
      end

      it "has the correct 'published in error' text" do
        within(".gem-c-heading + p") do
          expect(page).to have_text("The information on this page has been removed because it was published in error.")
        end
      end

      it "has the correct explanation" do
        within(".gem-c-govspeak") do
          expect(page).to have_text("Incorrect title")
        end
      end

      it "doesn't render an explanation if the explanation is nil" do
        content_store_response["details"]["explanation"] = nil
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path
        expect(page).not_to have_css(".gem-c-govspeak")
      end

      it "doesn't render an explanation if the explanation is blank" do
        content_store_response["details"]["explanation"] = " "
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path
        expect(page).not_to have_css(".gem-c-govspeak")
      end

      it "has the correct locale on the explanation" do
        content_store_response["locale"] = "cy"
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path
        expect(page).to have_css(".gem-c-heading + p[lang=cy]")
      end
    end

    context "when there is an alternative path" do
      before do
        content_store_response["details"]["alternative_path"] = "/this-is-the-alternative-path"
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path
      end

      it "displays the page" do
        expect(page.status_code).to eq(200)
      end

      it "has the correct alternative path text" do
        within(".gem-c-govspeak + p.govuk-body") do
          expect(page).to have_text("Visit: /this-is-the-alternative-path")
        end
      end

      it "has the correct alternative path text translation" do
        content_store_response["locale"] = "cy"
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path
        within(".gem-c-govspeak + p.govuk-body") do
          expect(page).to have_text("Ymweld: /this-is-the-alternative-path")
        end
      end

      it "has the correct alternative path link" do
        within("main") do
          expect(page).to have_link("/this-is-the-alternative-path", href: "/this-is-the-alternative-path")
        end
      end

      it "doesn't render an alternative path if it is nil" do
        content_store_response["details"]["alternative_path"] = nil
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path
        within("main") do
          expect(page).not_to have_text("Visit: /this-is-the-alternative-path")
          expect(page).not_to have_link("/this-is-the-alternative-path", href: "/this-is-the-alternative-path")
        end
      end

      it "doesn't render an alternative path if it is blank" do
        content_store_response["details"]["alternative_path"] = " "
        stub_content_store_has_item(base_path, content_store_response)
        visit base_path
        within("main") do
          expect(page).not_to have_text("Visit: /this-is-the-alternative-path")
          expect(page).not_to have_link("/this-is-the-alternative-path", href: "/this-is-the-alternative-path")
        end
      end
    end
  end
end
