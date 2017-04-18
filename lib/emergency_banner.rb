class EmergencyBanner
  def enabled?
    content[:heading].present? && content[:campaign_class].present?
  end

private

  def connection
    Redis.new
  end

  def content
    @data ||= connection.hgetall("emergency_banner")
    @data.symbolize_keys if @data
  end
end
