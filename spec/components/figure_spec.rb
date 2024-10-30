RSpec.describe "FigureComponent", type: :view do
  def component_name
    "figure"
  end

  it "fails to render a figure when no data is given" do
    expect { render_component({}) }.to raise_error(ActionView::Template::Error)
  end

  it "fails to render an image when no source is given" do
    render_component(src: "", alt: "")

    expect(rendered).not_to have_css("img")
  end

  it "renders a figure correctly" do
    render_component(src: "/image", alt: "image alt text")

    expect(rendered).to have_css(".app-c-figure__image[src=\"/image\"]")
    expect(rendered).to have_css(".app-c-figure__image[alt=\"image alt text\"]")
  end

  it "renders a figure with caption correctly" do
    render_component(src: "/image", alt: "image alt text", caption: "This is a caption")

    expect(rendered).to have_css(".app-c-figure__image[src=\"/image\"]")
    expect(rendered).to have_css(".app-c-figure__image[alt=\"image alt text\"]")
    expect(rendered).to have_css(".app-c-figure__figcaption .app-c-figure__figcaption-text", text: "This is a caption")
  end

  it "renders a figure with credit correctly" do
    render_component(src: "/image", alt: "image alt text", credit: "Creative Commons")

    expect(rendered).to have_css(".app-c-figure__image[src=\"/image\"]")
    expect(rendered).to have_css(".app-c-figure__image[alt=\"image alt text\"]")
    expect(rendered).to have_css(".app-c-figure__figcaption .app-c-figure__figcaption-text", text: "Image credit: Creative Commons")
  end

  it "renders a figure with caption and credit correctly" do
    render_component(src: "/image", alt: "image alt text", caption: "This is a caption", credit: "Creative Commons")

    expect(rendered).to have_css(".app-c-figure__image[src=\"/image\"]")
    expect(rendered).to have_css(".app-c-figure__image[alt=\"image alt text\"]")
    expect(rendered).to have_css(".app-c-figure__figcaption .app-c-figure__figcaption-text", text: "This is a caption")
    expect(rendered).to have_css(".app-c-figure__figcaption .app-c-figure__figcaption-text", text: "Image credit: Creative Commons")
  end
end
