module Sprockets
  class Asset
    def digest_path
      if DigestUtils.already_digested?(@name)
        logical_path
      else
        "#{get_prefix(logical_path:)}/#{logical_path.sub(/\.(\w+)$/) { |ext| "-#{etag}#{ext}" }}"
      end
    end

    def get_prefix(logical_path:)
      assets_config.shared.each do |shared_element_prefix|
        return "shared" if logical_path.start_with?(shared_element_prefix)
      end

      assets_config.default_folder
    end

    def assets_config
      ::Rails.application.config.assets
    end
  end
end
