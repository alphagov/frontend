class LandingPage::BlockFactory
  def self.build_all(block_array, landing_page)
    (block_array || []).map { |block| build(block, landing_page) }
  end

  def self.build(block_hash, landing_page)
    block_class(block_hash["type"]).new(block_hash, landing_page)
  rescue StandardError => e
    LandingPage::Block::BlockError.new({ "type" => "block_error", "error" => e }, landing_page)
  end

  def self.block_class(type)
    "LandingPage::Block::#{type.camelize}".constantize
  rescue StandardError
    raise("Couldn't identify a model class for type: #{type}")
  end
end
