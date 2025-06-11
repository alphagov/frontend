RSpec.describe "Service manual service standard page" do
  describe "GET /<document_type>" do
    let(:content_store_response) { GovukSchemas::Example.find("service_manual_service_standard", example_name: "service_manual_service_standard") }
    let(:base_path) { content_store_response.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path
    end

    it "service standard page has a heading, summary and intro" do
      expect(page).to have_css(".gem-c-heading__text", text: "Service Standard"), "No title found"
      expect(page).to have_css(".app-page-header__summary", text: "The Service Standard is a set of 18 criteria to help government create and run good digital services."), "No description found"
      expect(page).to have_css(".app-page-header__intro", text: "All public facing transactional services must meet the standard. It’s used by departments and the Government Digital Service to check whether a service is good enough for public use."), "No body found"
    end

    it "service standard page has points" do
      expect(points.length).to eq(3)

      within(points[0]) do
        expect(page).to have_text("1. Understand user needs")
        expect(page).to have_content(/Research to develop a deep knowledge/), "Description not found"
        expect(page).to have_link("Read more about point 1", href: "/service-manual/service-standard/understand-user-needs"), "Link not found"
      end

      within(points[1]) do
        expect(page).to have_text("2. Do ongoing user research")
        expect(page).to have_content(/Put a plan in place/), "Description not found"
        expect(page).to have_link("Read more about point 2", href: "/service-manual/service-standard/do-ongoing-user-research"), "Link not found"
      end

      within(points[2]) do
        expect(page).to have_text("3. Have a multidisciplinary team")
        expect(page).to have_content(/Put in place a sustainable multidisciplinary/), "Description not found"
        expect(page).to have_link("Read more about point 3", href: "/service-manual/service-standard/have-a-multidisciplinary-team"), "Link not found"
      end
    end

    it "each point has an anchor tag so that they can be linked to externally" do
      within("#criterion-1") do
        expect(page).to have_text("1. Understand user needs")
      end

      within("#criterion-2") do
        expect(page).to have_text("2. Do ongoing user research")
      end

      within("#criterion-3") do
        expect(page).to have_text("3. Have a multidisciplinary team")
      end
    end

    it "includes a link to subscribe for email alerts" do
      expect(page).to have_link(
        "email",
        href: "/email-signup?link=/service-manual/service-standard",
      )
    end

    def points
      find_all(".app-service-standard-point")
    end
  end
end
