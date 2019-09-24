class PostcodeSanitizer
  def self.sanitize(postcode)
    if postcode.present?
      # Strip trailing whitespace, non-alphanumerics, and use the
      # uk_postcode gem to potentially transpose O/0 and I/1.
      UKPostcode.parse(postcode.gsub(/[^a-z0-9 ]/i, "").strip).to_s
    end
  end
end
