class LocalAuthorityPresenter
  def initialize(local_authority)
    @local_authority = local_authority
  end

  PASS_THROUGH_KEYS = [
    :name,
    :snac,
    :tier,
    :contact_address,
    :contact_url,
    :contact_phone,
    :contact_email,
    :homepage_url,
  ]

  PASS_THROUGH_KEYS.each do |key|
    define_method key do
      local_authority[key.to_s]
    end
  end

  def url
    @_url ||= extract_first_url
  end

private

  attr_accessor :local_authority

  def extract_first_url
    homepage_url.presence || contact_url.presence || nil
  end
end
