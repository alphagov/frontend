module ContentItemLoaders
  class YamlFileLoader < LocalFileLoader
  private

    def load_local_file(base_path)
      GdsApi::Response.new(OpenStruct.new(code: 200, body: YAML.load(File.read(local_filename(base_path))).to_json, headers:))
    end

    def local_filename(base_path)
      Rails.root.join("#{LOCAL_ITEMS_PATH}#{base_path}.yml")
    end
  end
end
