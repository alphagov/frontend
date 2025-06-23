RSpec.describe ServiceManualGuidePresenter do
  let(:content_store_response) { GovukSchemas::Example.find("service_manual_guide", example_name: "service_manual_guide") }

  let(:content_item) do
    ServiceManualGuide.new(content_store_response)
  end

  let(:presenter) do
    described_class.new(content_item)
  end

  it "presents the basic details required to display a Service Manual Guide" do
    expect(presenter.header_links.size >= 1).to be(true)

    content_owner = presenter.content_owners.first
    expect(content_owner.title.present?).to be(true)
    expect(content_owner.href.present?).to be(true)
  end

  it "breadcrumbs have a root and a topic link" do
    expect(presenter.breadcrumbs).to eq([
      { title: "Service manual", url: "/service-manual" },
      { title: "Agile", url: "/service-manual/agile" },
    ])
  end

  it "breadcrumbs gracefully omit topic if it's not present" do
    content_store_response["links"]["service_manual_topics"] = {}
    content_store_response["links"]["parent"] = {}
    content_item = ServiceManualGuide.new(content_store_response)
    presenter = described_class.new(content_item)

    expect(presenter.breadcrumbs).to eq([
      { title: "Service manual", url: "/service-manual" },
    ])
  end

  it "#category_title is the title of the category" do
    expect(presenter.category_title).to eq("Agile")
  end

  describe "#category_title" do
    context "when there are no links" do
      let(:content_store_response) do
        GovukSchemas::Example.find("service_manual_guide", example_name: "service_manual_guide").tap { |i| i["links"] = {} }
      end

      it "returns nil" do
        expect(presenter.category_title).to be_nil
      end
    end

    context "when looking at a point page under the service standard" do
      let(:content_store_response) do
        GovukSchemas::Example.find("service_manual_guide", example_name: "point_page")
      end

      it "#category_title is the title of the parent for a point" do
        expect(presenter.category_title).to eq("The Service Standard")
      end
    end
  end

  it "#content_owners when stored in the links" do
    content_store_response["details"] = { "content_owner" => nil }
    content_store_response["links"] = { "content_owners" => [{
      "content_id" => "e5f09422-bf55-417c-b520-8a42cb409814",
      "title" => "Agile delivery community",
      "base_path" => "/service-manual/communities/agile-delivery-community",
    }] }
    content_item = ServiceManualGuide.new(content_store_response)
    presenter = described_class.new(content_item)

    expected = [
      ServiceManualGuidePresenter::ContentOwner.new(
        "Agile delivery community",
        "/service-manual/communities/agile-delivery-community",
      ),
    ]

    expect(presenter.content_owners).to eq(expected)
  end

  it "#show_description? is false if not set" do
    content_store_response["details"]["show_description"] = nil
    content_item = ServiceManualGuide.new(content_store_response)
    presenter = described_class.new(content_item)

    expect(presenter.show_description?).to be(false)
  end

  it "#public_updated_at returns a time" do
    expect(presenter.public_updated_at).to be_a(Time)
  end

  it "#public_updated_at returns nil if not available" do
    content_store_response["public_updated_at"] = nil
    content_item = ServiceManualGuide.new(content_store_response)
    presenter = described_class.new(content_item)

    expect(presenter.public_updated_at).to be_nil
  end

  it "#visible_updated_at returns the public_updated_at" do
    timestamp = "2015-10-10T09:00:00+00:00"
    content_store_response["public_updated_at"] = timestamp
    content_item = ServiceManualGuide.new(content_store_response)
    presenter = described_class.new(content_item)

    expect(presenter.visible_updated_at).to eq(Time.zone.parse(timestamp))
  end

  it "#visible_updated_at returns the updated_at time if the public_updated_at hasn't yet been set" do
    timestamp = "2015-10-10T09:00:00+00:00"
    content_store_response["updated_at"] = timestamp
    content_store_response["public_updated_at"] = nil
    content_item = ServiceManualGuide.new(content_store_response)
    presenter = described_class.new(content_item)

    expect(presenter.visible_updated_at).to eq(Time.zone.parse(timestamp))
  end

  it "#latest_change returns the details for the most recent change" do
    expected_history = ServiceManualGuidePresenter::Change.new(
      Time.zone.parse("2015-10-09T08:17:10+00:00"),
      "This is our latest change",
    )

    expect(presenter.latest_change).to eq(expected_history)
  end

  it "#latest_change timestamp is the updated_at time if public_updated_at hasn't been set" do
    timestamp = "2015-10-07T09:00:00+00:00"
    content_store_response["updated_at"] = timestamp
    content_store_response["public_updated_at"] = nil

    content_item = ContentItem.new(content_store_response)
    presenter = described_class.new(content_item)

    expected_history = ServiceManualGuidePresenter::Change.new(
      Time.zone.parse(timestamp),
      "This is our latest change",
    )

    expect(presenter.latest_change).to eq(expected_history)
  end

  it "#previous_changes returns the change history for the guide" do
    expected_history = [
      ServiceManualGuidePresenter::Change.new(
        Time.zone.parse("2015-09-09T08:17:10+00:00"),
        "This is another change",
      ),
      ServiceManualGuidePresenter::Change.new(
        Time.zone.parse("2015-09-01T08:17:10+00:00"),
        "Guidance first published",
      ),
    ]

    expect(presenter.previous_changes).to eq(expected_history)
  end

  it "#header_links returns a list of hrefs and text" do
    expect(presenter.header_links).to eq([{ "text" => "What is it, why it works and how to do it", "href" => "#what-is-it-why-it-works-and-how-to-do-it" }])
  end
end
