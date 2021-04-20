class Uprn
  UPRN_PATTERN = %r{^\d{1,12}$}.freeze

  def initialize(uprn)
    @uprn = uprn || ""
  end

  def valid?
    sanitized_uprn.match?(UPRN_PATTERN)
  end

  def sanitized_uprn
    uprn.strip
  end

  def error
    return "uprnLeftBlankSanitized" if sanitized_uprn.blank?
    return "invalidUprnFormat" unless valid?
  end

private

  attr_reader :uprn
end
