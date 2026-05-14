require "ostruct"

module ContentItemLoaders
  class LocalFileLoader
    LOCAL_ITEMS_PATH = "lib/data/local-content-items".freeze

    def can_load?(base_path:)
      use_local_file? && File.exist?(local_filename(base_path))
    end

    def load(base_path:)
      Rails.logger.debug("Loading content item #{base_path} from #{local_filename(base_path)}")
      load_local_file(base_path)
    end

    def local_filename(base_path)
      Rails.root.join("#{LOCAL_ITEMS_PATH}#{base_path}.json")
    end

    def load_local_file(base_path)
      GdsApi::Response.new(OpenStruct.new(code: 200, body: File.read(local_filename(base_path)), headers:))
    end

  private

    def headers
      { cache_control: "max-age=0, public", expires: "" }
    end

    def use_local_file?
      ENV["ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE"] == "true"
    end
  end
end
