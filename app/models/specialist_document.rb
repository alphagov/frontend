class SpecialistDocument < ContentItem
  attr_reader :continuation_link, :will_continue_on

  def initialize(content_store_response)
    super(content_store_response)

    @continuation_link = content_store_hash.dig("details", "metadata", "continuation_link")
    @will_continue_on = content_store_hash.dig("details", "metadata", "will_continue_on")
  end
end
