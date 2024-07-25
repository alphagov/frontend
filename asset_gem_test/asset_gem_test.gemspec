require_relative "lib/asset_gem_test/version"

Gem::Specification.new do |spec|
  spec.name        = "asset_gem_test"
  spec.version     = AssetGemTest::VERSION
  spec.authors     = [""]
  spec.email       = [""]
  spec.homepage    = "https://www.gov.uk"
  spec.summary     = "Test for asset compilation pipeline gem."
  spec.description = "Test for asset compilation pipeline gem."

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://www.gov.uk"
  spec.metadata["changelog_uri"] = "https://www.gov.uk"

  spec.required_ruby_version = ">= 3.2"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.3.4"
end
