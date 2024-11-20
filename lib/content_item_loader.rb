require "ostruct"

class ContentItemLoader
  LOCAL_ITEMS_PATH = "lib/data/local-content-items".freeze

  @cache = {}

  class << self
    attr_reader :cache

    def load(base_path)
      cache[base_path] ||= if use_local_file? && File.exist?(yaml_filename(base_path))
                             Rails.logger.debug("Loading content item #{base_path} from #{yaml_filename(base_path)}")
                             load_yaml_file(base_path)
                           elsif use_local_file? && File.exist?(json_filename(base_path))
                             Rails.logger.debug("Loading content item #{base_path} from #{json_filename(base_path)}")
                             load_json_file(base_path)
                           else
                             begin
                               GdsApi.content_store.content_item(base_path)
                             rescue GdsApi::HTTPErrorResponse, GdsApi::InvalidUrl => e
                               e
                             end
                           end
    end

  private

    def use_local_file?
      ENV["ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE"] == "true"
    end

    def yaml_filename(base_path)
      Rails.root.join("#{LOCAL_ITEMS_PATH}#{base_path}.yml")
    end

    def load_yaml_file(base_path)
      GdsApi::Response.new(OpenStruct.new(code: 200, body: YAML.load(File.read(yaml_filename(base_path))).to_json, headers:))
    end

    def json_filename(base_path)
      Rails.root.join("#{LOCAL_ITEMS_PATH}#{base_path}.json")
    end

    def load_json_file(base_path)
      GdsApi::Response.new(OpenStruct.new(code: 200, body: File.read(json_filename(base_path)), headers:))
    end

    def headers
      { cache_control: "max-age=0, public", expires: "" }
    end
  end
end
