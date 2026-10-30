require "percy/capybara"
require "uri"
# simplecov:disable
RSpec.describe "Visual regression tests", :visual_regression do
  include ContentStoreHelpers
  # rubocop:disable RSpec/NoExpectationExample
  describe "visual regression test runner Percy" do
    before do
      Capybara.current_driver = Capybara.javascript_driver
      Capybara.default_max_wait_time = 20
    end

    after do
      Capybara.use_default_driver
      Capybara.default_max_wait_time = 2
    end

    it "takes a screenshot of a subset of pages" do
      # This code iterates through each folder in `alphagov/publishing-api/content_schemas/examples/`, grabs each content item, and then visits that content item and takes a screenshot.

      path = Pathname.new(ENV["GOVUK_CONTENT_SCHEMAS_PATH"] || "../publishing-api/content_schemas").join("examples")
      d = Dir.new(path)
      # Each folder in `alphagov/publishing-api/content_schemas/examples/`
      d.sort.each do |schema|
        frontend_dir = Pathname.new(path).join(schema).join("frontend")

        next unless Dir.exist?(frontend_dir) # Ensures the schema has a "frontend" folder (which means it's rendered by any GOVUK frontend app, not the 'frontend' repo specifically)

        # A child folder like `alphagov/publishing-api/content_schemas/examples/answer` can have multiple content item examples, so loop through all of them.
        frontend_dir.each_child do |schema_example|
          example_name = schema_example.to_s

          content_item = JSON.load_file(example_name)
          next unless content_item["rendering_app"] == "frontend"

          base_path = content_item["base_path"]

          example_name_clean = example_name.split("/").last.split(".").first # E.g. converts "publishing-api/content_schemas/examples/answer/frontend/answer.json" to "answer"
          content_store_has_example_item(base_path, schema:, example: example_name_clean)

          begin
            puts("Visiting #{example_name_clean} at #{base_path}")
            visit(base_path)

            page.find(:css, ".govuk-footer", wait: 20)

            puts("Taking a screenshot of #{example_name_clean}")
            page.percy_snapshot("#{example_name_clean} (#{base_path})")

          # Sometimes rendering a page locally crashes, either because it's a special page, it's redirecting infinitely, or it's erroring for reasons that are difficult to fix, so skip those pages.
          rescue WebMock::NetConnectNotAllowedError, ActionView::Template::Error, ActionController::RoutingError, Capybara::ElementNotFound, Capybara::CapybaraError => e
            puts("Failed to take a screenshot of: #{example_name_clean} at #{base_path}")
            puts e
          end
        end
      end
    end
  end
  # rubocop:enable RSpec/NoExpectationExample
end
# simplecov:enable
