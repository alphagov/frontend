require "ostruct"

class ContentItemLoader
  LOCAL_ITEMS_PATH = "config/local-content-items".freeze

  @cache = {}

  class << self
    attr_reader :cache

    def load(base_path)
      cache[base_path] ||= if ENV["ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE"] == "true" && local_file?(base_path)
                             load_local_file(base_path)
                           else
                             begin
                               GdsApi.content_store.content_item(base_path)
                             rescue GdsApi::HTTPErrorResponse, GdsApi::InvalidUrl => e
                               e
                             end
                           end
    end

    def local_file?(base_path)
      File.exist?(local_json_filename(base_path)) || File.exist?(local_yaml_filename(base_path))
    end

    def local_json_filename(base_path)
      Rails.root.join("#{LOCAL_ITEMS_PATH}#{base_path}.json")
    end

    def local_yaml_filename(base_path)
      Rails.root.join("#{LOCAL_ITEMS_PATH}#{base_path}.yml")
    end

    def load_local_file(base_path)
      body = if File.exist?(local_json_filename(base_path))
               Rails.logger.debug("Loading content item #{base_path} from #{local_json_filename(base_path)}")
               File.read(local_json_filename(base_path))
             else
               Rails.logger.debug("Loading content item #{base_path} from #{local_yaml_filename(base_path)}")
               YAML.load(File.read(local_yaml_filename(base_path))).to_json
             end

      GdsApi::Response.new(OpenStruct.new(code: 200, body:, headers: { cache_control: "", expires: "" }))
    end
  end
end
