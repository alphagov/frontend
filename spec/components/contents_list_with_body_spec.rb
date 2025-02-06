RSpec.describe "ContentsListWithBodyComponent", type: :view do
  def component_path
    "components/contents_list_with_body"
  end

  def contents_list
    [
      { href: "/one", text: "1. One" },
      { href: "/two", text: "2. Two" },
    ]
  end

  def block
    "<p>Foo</p>".html_safe
  end

  it "renders nothing without a block" do
    expect(render(component_path, contents: contents_list)).to be_empty
  end

  it "yields the block without contents data" do
    expect(render(component_path, {}) { block }).to include(block)
  end

  it "renders a sticky-element-container" do
    render(component_path, contents: contents_list) { block }

    expect(rendered).to have_selector("#contents.app-c-contents-list-with-body")
    expect(rendered).to have_selector("#contents[data-module='sticky-element-container']")
  end

  it "does not apply the sticky-element-container data-module without contents data" do
    expect(render(component_path, {}) { block }).not_to have_selector("#contents[data-module='sticky-element-container']")
  end

  it "renders a contents-list component" do
    render(component_path, contents: contents_list) { block }

    expect(rendered).to have_css(".app-c-contents-list-with-body .gem-c-contents-list")
    expect(rendered).to have_css(".gem-c-contents-list__link[href='/one']", text: "1. One")
  end

  it "renders a back-to-top component" do
    render(component_path, contents: contents_list) { block }
    expect(rendered).to have_css(".app-c-contents-list-with-body
    .app-c-contents-list-with-body__link-wrapper .app-c-contents-list-with-body__link-container .app-c-back-to-top[href='#contents']")
  end
end
