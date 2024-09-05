module LinksHelper
  def feed_link(base_path)
    "#{base_path}.atom"
  end

  def print_link(base_path)
    "#{base_path}/print"
  end
end
