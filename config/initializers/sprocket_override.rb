module Sprockets
  class Asset
    def digest_path
      if DigestUtils.already_digested?(@name)
        logical_path
      else
        prefix = if logical_path.start_with?("asset_gem_test")
                   "shared"
                 elsif logical_path.start_with?("govuk_publishing_components")
                   "shared"
                 else
                   "frontend"
                 end
        "#{prefix}/#{logical_path.sub(/\.(\w+)$/) { |ext| "-#{etag}#{ext}" }}"
      end
    end
  end
end
