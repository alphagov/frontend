RSpec.describe ServiceManualServiceStandard do
  describe "#points" do
    subject(:service_manual_service_standard) { described_class.new(content_store_response) }

    let(:content_store_response) do
      GovukSchemas::Example.find("service_manual_service_standard", example_name: "service_manual_service_standard")
    end

    it "returns the expected response" do
      expect(service_manual_service_standard.points.size).to eq(3)

      titles = ["1. Understand user needs", "2. Do ongoing user research", "3. Have a multidisciplinary team"]
      descriptions = ["Understand user needs. Research to develop a deep knowledge of who the service users are and what that means for the design of the service.",
                      "Put a plan in place for ongoing user research and usability testing to continuously seek feedback from users to improve the service.",
                      "Put in place a sustainable multidisciplinary team that can design, build and operate the service, led by a suitably skilled and senior service manager with decision-making responsibility."]
      base_paths = ["/service-manual/service-standard/understand-user-needs", "/service-manual/service-standard/do-ongoing-user-research", "/service-manual/service-standard/have-a-multidisciplinary-team"]

      service_manual_service_standard.points.each_with_index do |point, index|
        expect(point.title).to eq(titles[index])
        expect(point.description).to eq(descriptions[index])
        expect(point.base_path).to eq(base_paths[index])
        expect(point.number).to eq(index + 1)
      end
    end
  end
end
