RSpec.describe "GovspeakTranslatorComponent", type: :view do
  def component_name
    "govspeak_translator"
  end

  it "renders nothing when required params are not passed" do
    expect(render_component({})).to be_empty
  end

  it "transforms simple markdown into markup" do
    render "components/#{component_name}" do
      "##heading"
    end

    expect(rendered).to include("<h2 id=\"heading\">heading</h2>")
  end
end
