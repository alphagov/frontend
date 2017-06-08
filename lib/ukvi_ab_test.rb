module UkviABTest
  def self.valid_path?(path)
    paths = path.split('/')
    (paths.include?("remain-in-uk-family") ||
      paths.include?("join-family-in-uk"))
  end
end
