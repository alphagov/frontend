RSpec.describe "BackToTopComponent", type: :view do
  def component_name
    "back_to_top"
  end

  it "fails to render a back to top link when no parameters given" do
    expect { render_component({}) }.to raise_error(ActionView::Template::Error)
  end

  it "renders a back to top link when a href is given" do
    render_component(href: "#contents")

    expect(rendered).to have_css(".app-c-back-to-top[href='#contents']")
  end

  it "renders a back to top link with custom text" do
    render_component(href: "#contents", text: "Back to top")

    expect(rendered).to have_css(".app-c-back-to-top[href='#contents']", text: "Back to top")
  end
end
