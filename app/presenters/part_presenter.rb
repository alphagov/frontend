class PartPresenter
  attr_reader :part

  def initialize(part)
    @part = part
  end

  PASS_THROUGH_KEYS = [
    :slug, :title, :body, :name
  ]

  PASS_THROUGH_KEYS.each do |key|
    define_method key do
      part[key.to_s]
    end
  end
end
