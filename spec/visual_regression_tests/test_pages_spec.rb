require "percy/capybara"
require "uri"
require "yaml"

# simplecov:disable
RSpec.describe "Visual regression tests", :visual_regression do
  include ContentStoreHelpers
  # rubocop:disable RSpec/NoExpectationExample
  describe "visual regression test runner Percy" do
    before do
      Capybara.current_driver = :selenium_chrome
      Capybara.default_max_wait_time = 30
    end

    after do
      Capybara.use_default_driver
      Capybara.default_max_wait_time = 2
    end

    it "takes a screenshot of app components", :js do
      path = Pathname.new("app/views/components/docs")
      d = Dir.new(path)
      d.sort.each do |component|
        next if [".", ".."].include?(component)

        component = component.gsub(".yml", "")

        if component == "map"
          map = YAML.load_file(Pathname.new(path).join("#{component}.yml"))
          map_example_count = map["examples"].count
          visit("/component-guide/map/preview")
          page.assert_selector("[data-map-loaded]", minimum: map_example_count, wait: 30)
        else
          visit("/component-guide/#{component}/preview")
        end
        puts("Taking a screenshot of '/component-guide/#{component}/preview'")
        page.percy_snapshot(component)
      end
    end
  end
  # rubocop:enable RSpec/NoExpectationExample
end
# simplecov:enable
