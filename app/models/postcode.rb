class Postcode
  class InvalidPostcodeError < StandardError; end

  GEOGRAPHIC_POSTCODE_PATTERN = /
    \A ( [A-PR-UWYZ01][A-HJ-Z0]? )     # area
    (?: ( [0-9IO][0-9A-HJKMNPR-YIO]? ) # district
      (?: \s* ( [0-9IO] )              # sector
        ( [ABD-HJLNPQ-Z]{2} )? )? )?   # unit
    \Z
  /ix

  def initialize(str)
    matched = GEOGRAPHIC_POSTCODE_PATTERN.match((str || "").strip)
    raise InvalidPostcodeError unless matched && matched.captures.compact.count == 4

    parts = (1..4).map { |i| matched[i] }
    @outcode = letters_only(parts[0]) + digits_only(parts[1])
    @incode = digits_only(parts[2]) + letters_only(parts[3])
  end

  def to_s
    "#{@outcode} #{@incode}"
  end

  def compressed
    @outcode + @incode
  end

private

  def letters_only(str)
    str.upcase.tr("10", "IO")
  end

  def digits_only(str)
    str.upcase.tr("IO", "10")
  end
end
