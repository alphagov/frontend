require "component_test_helper"

class SubscribeComponentTest < ComponentTestCase
  def component_name
    "subscribe"
  end

  test "fails to render when no parameters given" do
    assert_raise do
      render_component({})
    end
  end

  test "renders the component when link data is passed" do
    render_component({
      label: "label",
      url: "https://www.gov.uk",
      title: "title",
    })
    assert_select ".app-c-subscribe a[href='https://www.gov.uk'][title='title']", text: "label"
  end

  test "renders the component with data attributes" do
    render_component({
      label: "label",
      url: "https://www.gov.uk",
      title: "title",
      data: {
        module: "test-module",
        ok: "go",
      },
    })
    assert_select ".app-c-subscribe a[href='https://www.gov.uk'][title='title']", text: "label"
    assert_select ".app-c-subscribe a[data-module='test-module'][data-ok='go']"
  end
end
