module PhoneNumberHelper
  UK_PHONE_REGEX = /^((\(?0\d{2}\)?\s?\d{4}\s?\d{4}))?/

  def phone_digits(phone_number)
    UK_PHONE_REGEX.match(phone_number)[0]
  end

  def phone_text(phone_number)
    UK_PHONE_REGEX.match(phone_number).post_match.strip
  end
end
