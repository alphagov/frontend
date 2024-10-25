class LandingPage::LandingPageTree
  attr_reader :node
  delegate :base_path, :title, to: :node

  SimpleNode = Data.define(:base_path, :title, :children)

  def initialize(landing_page, group_title)
    @node = landing_page
    @group_title = group_title
  end

  def parent
    @parent ||= retrieve_parent
  end

  def root
    parent.nil? ? self : parent.root
  end

  def children
    @children ||= retrieve_children
  end

private

  def retrieve_parent
    parent_landing_page_hash = node.document_collections&.find { _1["schema_name"] == "landing_page" }
    return nil if parent_landing_page_hash.nil?

    landing_page = LandingPage.fetch_by_base_path(parent_landing_page_hash["base_path"])
    LandingPageTree.new(landing_page, @group_title)
  end

  def retrieve_children
    return [] if node.documents.nil?

    collection_group = node.collection_groups&.find { _1["title"] == @group_title }
    return [] if collection_group.nil?

    linked_documents_by_content_id = node.documents.group_by { _1["content_id"] }
    content_ids_in_group = collection_group.fetch("documents")
    linked_documents_in_group = linked_documents_by_content_id.values_at(*content_ids_in_group)

    linked_documents_in_group.map do |linked_doc|
      base_path, schema_name, title = linked_doc.values_at("base_path", "schema_name", "title")

      if schema_name == "landing_page"
        landing_page = LandingPage.fetch_by_base_path(base_path)
        LandingPageTree.new(landing_page, @group_title)
      else
        SimpleNode.new(base_path:, title:, children: [])
      end
    end
  end
end
