module AssetGemTest
  class Engine < ::Rails::Engine
    isolate_namespace AssetGemTest

    initializer "asset_gem_test.assets.precompile" do |app|
      app.config.assets.precompile += %w[*.png]
    end
  end
end
