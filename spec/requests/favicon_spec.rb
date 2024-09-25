RSpec.describe "Favicon" do
  it "redirects permanently to an asset with a 1 day expiry" do
    get "/favicon.ico"

    expect(response.headers["Cache-Control"]).to eq("max-age=86400, public")
    expect(response.status).to eq(301)
    expect(response.location).to match(/http:\/\/www.example.com\/assets\/frontend\/favicon-(.+).ico/)
  end
end
