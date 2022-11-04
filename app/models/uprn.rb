class Uprn
  UPRN_PATTERN = %r{^\d{1,12}$}

  delegate :present?, to: :sanitized_uprn

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
    return "invalidUprnFormat" unless valid?
  end

private

  attr_reader :uprn
end
