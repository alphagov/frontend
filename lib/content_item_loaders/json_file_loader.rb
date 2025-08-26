module ContentItemLoaders
  class JsonFileLoader < LocalFileLoader
  private

    def local_filename(base_path)
      Rails.root.join("#{LOCAL_ITEMS_PATH}#{base_path}.json")
    end

    def load_local_file(base_path)
      GdsApi::Response.new(OpenStruct.new(code: 200, body: File.read(local_filename(base_path)), headers:))
    end
  end
end
