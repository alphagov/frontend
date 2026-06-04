RSpec.describe "NestedNavigationComponent", type: :view do
  def component_name
    "nested_navigation"
  end

  items = [{ "text" => "Service Name", "href" => "/service-name" }, { "text" => "A basic link", "href" => "/something" }, { "text" => "Nested Heading", "links" => [{ "text" => "Example Link", "href" => "/hello-world" }, { "text" => "Example Link 2", "href" => "/hello-world" }, { "text" => "Example Link 3", "href" => "/hello-world" }, { "text" => "This is a very very very long link", "href" => "/hello-world" }, { "text" => "Another link that has a lot of characters", "href" => "/hello-world" }, { "text" => "Third link containing a lot of text", "href" => "/hello-world" }] }, { "text" => "Third Link", "href" => "/example1" }, { "text" => "Fourth Link", "href" => "/example1" }]

  it "renders nothing without config" do
    render_component({})
    expect(rendered).not_to have_css(".app-c-nested-navigation")
  end

  it "renders the basic component" do
    render_component({ items: items })
    expect(rendered).to have_css(".app-c-nested-navigation")
    expect(rendered).to have_css("ul[data-module=nested-navigation]")
    expect(rendered).to have_css(".app-c-nested-navigation__service-name", text: "Service Name")
    expect(rendered).to have_css("button", text: " Nested Heading ")
    expect(rendered).to have_css(".app-c-nested-navigation__sub-list-item", text: "Example Link")
    expect(rendered).to have_css("li:last-of-type", text: "Fourth Link")
  end
end
