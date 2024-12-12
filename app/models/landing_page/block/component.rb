module LandingPage::Block
  class Component < Base
    ALLOWED_COMPONENTS = %w[
      action_link
      attachment
      back_link
      big_number
      button
      cards
      chat_entry
      contents_list
      copy_to_clipboard
      details
      document_list
      glance_metric
      govspeak
      heading
      image_card
      inset_text
      inverse_header
      lead_paragraph
      list
      notice
      organisation_logo
      page_title
      previous_and_next_navigation
      print_link
      share_links
      warning_text
    ].freeze

    attr_reader :component_name

    def initialize(block_hash, landing_page)
      super

      @component_name = data["component_name"]
      raise "Component #{component_name} is not in the allowed list of components for this block" unless ALLOWED_COMPONENTS.include?(component_name)
    end

    def component_attributes
      data.except("type", "component_name").symbolize_keys
    end
  end
end
