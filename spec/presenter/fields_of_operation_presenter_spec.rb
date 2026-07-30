RSpec.describe FieldsOfOperationPresenter do
  subject(:fields_of_operation_presenter) { described_class.new(content_item) }

  let(:content_store_response) { GovukSchemas::Example.find("fields_of_operation", example_name: "fields_of_operation") }
  let(:content_item) { FieldsOfOperation.new(content_store_response) }

  describe "#page_title_options" do
    it "has a context that differs from the content item" do
      expect(content_item.context).to be_nil
      expect(fields_of_operation_presenter.page_title_options[:context]).to eq("British fatalities")
    end

    it "has a context locale" do
      expect(fields_of_operation_presenter.page_title_options[:context_locale]).to eq(:en)
    end
  end
end
