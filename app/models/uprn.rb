class Uprn
  class InvalidUprnError < StandardError; end

  UPRN_PATTERN = %r{\A\d{1,12}\z}

  def initialize(uprn)
    @uprn = (uprn || "").strip
    raise InvalidUprnError unless @uprn.match?(UPRN_PATTERN)
  end

  def to_s
    @uprn
  end
end
