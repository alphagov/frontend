RSpec.describe CaseStudy do
  subject(:case_study) { described_class.new(content_store_response) }

  let(:content_store_response) do
    GovukSchemas::Example.find("case_study", example_name: "doing-business-in-spain")
  end

  it_behaves_like "it has updates", "case_study", "has-updates"
  it_behaves_like "it has no updates", "case_study", "doing-business-in-spain"
  it_behaves_like "it can have worldwide organisations", "case_study", "doing-business-in-spain"
  it_behaves_like "it can have emphasised organisations", "case_study", "doing-business-in-spain"

  describe "#contributors" do
    it "returns the organisations ordered by emphasis followed by worldwide organisations" do
      worldwide_organisations = content_store_response.dig("links", "worldwide_organisations")
      organisations = content_store_response.dig("links", "organisations")

      expect(case_study.contributors.count).to eq(3)
      expect(case_study.contributors[0].title).to eq(organisations[1]["title"])
      expect(case_study.contributors[1].title).to eq(organisations[0]["title"])
      expect(case_study.contributors[2].title).to eq(worldwide_organisations[0]["title"])
    end

    context "with no worldwide organisations" do
      let(:content_store_response) do
        example = GovukSchemas::Example.find("case_study", example_name: "doing-business-in-spain")
        example["links"].delete("worldwide_organisations")
        example
      end

      it "returns just the organisations ordered by emphasis" do
        organisations = content_store_response.dig("links", "organisations")

        expect(case_study.contributors.count).to eq(2)
        expect(case_study.contributors[0].title).to eq(organisations[1]["title"])
        expect(case_study.contributors[1].title).to eq(organisations[0]["title"])
      end
    end

    describe "#image" do
      describe "document is a case study with a custom lead image" do
        let(:content_store_response) { GovukSchemas::Example.find("case_study", example_name: "doing-business-in-spain") }

        it "fetches lead image from the details" do
          expect(case_study.image).to eq(content_store_response.dig("details", "image"))
        end
      end

      describe "document is a case study without a custom lead image" do
        let(:content_store_response) { GovukSchemas::Example.find("case_study", example_name: "doing-business-in-spain") }

        it "fetches lead image from primary publishing organisation" do
          content_store_response["details"] = content_store_response["details"].delete("image") # drop the custom image so we can test the fallback
          expect(case_study.image).to eq(content_store_response.dig("links", "primary_publishing_organisation")[0].dig("details", "default_news_image"))
        end
      end

      describe "document is a case study without a custom lead image, and no default news image on the primary organisation" do
        let(:content_store_response) { GovukSchemas::Example.find("case_study", example_name: "doing-business-in-spain") }

        it "does not fall back to non-primary organisations, nor uses the placeholder image" do
          content_store_response["details"] = content_store_response["details"].delete("image") # drop the custom image so we can test the fallback
          content_store_response["links"]["primary_publishing_organisation"][0]["details"]["default_news_image"] = nil # drop the default news image so we can test the fallback
          content_store_response["links"]["organisations"] = [
            { "details" =>
                {
                  "default_news_image" => {
                    "high_resolution_url" => "https://assets.publishing.service.gov.uk/media/621e4de4e90e0710be0354d7/s960_fcdo-main-building.jpg",
                    "url" => "https://assets.publishing.service.gov.uk/media/621e4de48fa8f5490aff83b4/s300_fcdo-main-building.jpg",
                  },
                } },
          ] # mock default news image on secondary organisation
          expect(case_study.image).to be_nil
        end
      end
    end
  end
end
