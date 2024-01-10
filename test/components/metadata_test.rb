require "component_test_helper"

class MetadataComponentTest < ComponentTestCase
  def component_name
    "metadata"
  end

  test "fails to render when no parameters given" do
    assert_raise do
      render_component({})
    end
  end

  test "renders the component when a date object is given" do
    render_component({
      last_updated: Date.parse("2-5-2008"),
    })
    assert_select ".app-c-meta-data", text: "Last updated: 2 May 2008"
  end
end
