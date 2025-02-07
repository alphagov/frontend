RSpec.describe "CSV previews" do
  it "routes old style paths to the CsvPreviewController" do
    expect(get("/media/000000000000000000000000/some-file.csv/preview")).to route_to(
      controller: "csv_preview",
      action: "show",
      id: "000000000000000000000000",
      filename: "some-file.csv",
    )
  end

  it "routes new style paths to the CsvPreviewController" do
    expect(get("/csv-preview/000000000000000000000000/some-file.csv")).to route_to(
      controller: "csv_preview",
      action: "show",
      id: "000000000000000000000000",
      filename: "some-file.csv",
    )
  end
end
