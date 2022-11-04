class ElectionPostcode
  UK_POSTCODE_PATTERN = %r{
    \A
    # Outward code, for example SW1A
    (([A-Z][0-9]{1,2})|(([A-Z][A-HJ-Y][0-9]{1,2})|(([A-Z][0-9][A-Z])|([A-Z][A-HJ-Y][0-9][A-Z]?))))
    \s?
    [0-9][A-Z]{2} # Inward code, for example 2AA
    \Z
  }xi

  delegate :present?, to: :sanitized_postcode

  def initialize(postcode)
    @postcode = postcode
  end

  def sanitized_postcode
    @sanitized_postcode ||= PostcodeSanitizer.sanitize(postcode)
  end

  def postcode_for_api
    sanitized_postcode.gsub(/\s+/, "")
  end

  def valid?
    sanitized_postcode.match?(UK_POSTCODE_PATTERN)
  end

  def error
    return "invalidPostcodeFormat" unless valid?
  end

private

  attr_reader :postcode
end
