class BlockFactory
  def self.build_all(block_array)
    (block_array || []).map { |block| build(block) }
  end

  def self.build(block_hash)
    block_class(block_hash["type"]).new(block_hash)
  end

  def self.block_class(type)
    klass = "Block::#{type.camelize}".constantize
    klass.ancestors.include?(Block::Base) ? klass : Block::Base
  rescue StandardError
    Block::Base
  end
end
