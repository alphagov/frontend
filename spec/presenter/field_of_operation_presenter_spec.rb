RSpec.describe FieldOfOperationPresenter do
  def subject(content_item)
    described_class.new(content_item)
  end

  let(:content_store_response) { GovukSchemas::Example.find("field_of_operation", example_name: "field_of_operation") }

  let(:content_item) do
    FieldOfOperation.new(content_store_response)
  end

  it "presents a description" do
    expect(subject(content_item).description).to eq("It is with very deep regret that the following fatalities are announced.")
  end

  it "presents the organisations object" do
    expected = {
      name: "Ministry<br/>of Defence",
      url: "/government/organisations/ministry-of-defence",
      brand: "ministry-of-defence",
      crest: "mod",
    }

    expect(subject(content_item).organisation).to eq(expected)
  end

  it "presents contents when fields of operation and fatalities are present" do
    expected = [
      { href: "#field-of-operation", text: "Field of operation" },
      { href: "#fatalities", text: "Fatalities" },
    ]

    expect(subject(content_item).contents).to eq(expected)
  end

  it "presents contents when only fields of operation are present" do
    content_store_response["links"]["fatality_notices"] = nil
    without_fatalities = FieldOfOperation.new(content_store_response)

    presented = described_class.new(without_fatalities)

    expected = [
      { href: "#field-of-operation", text: "Field of operation" },
    ]

    expect(presented.contents).to eq(expected)
  end

  it "presents contents when only fatalities are present" do
    content_store_response["description"] = nil
    without_description = FieldOfOperation.new(content_store_response)

    presented = described_class.new(without_description)

    expected = [
      { href: "#fatalities", text: "Fatalities" },
    ]

    expect(presented.contents).to eq(expected)
  end

  it "presents an empty array when neither fatalities nor description are present" do
    content_store_response["links"]["fatality_notices"] = nil
    content_store_response["description"] = nil

    without_description_or_fatalities = FieldOfOperation.new(content_store_response)

    presented = described_class.new(without_description_or_fatalities)

    expect(presented.contents).to eq([])
  end
end
