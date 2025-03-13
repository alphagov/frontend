class Graphql::FatalityNoticeQuery
  def initialize(base_path)
    @base_path = base_path
  end

  def query
    <<-QUERY
        {
          edition(
            base_path: "#{@base_path}",
            content_store: "live",
          ) {
            ... on Edition {
              base_path
              description
              details {
                body
                casualties
                change_history
                emphasised_organisations
                first_public_at
                roll_call_introduction
              }
              document_type
              first_published_at
              links {
                field_of_operation {
                  base_path
                  title
                  schema_name
                }
                organisations {
                  base_path
                  content_id
                  title
                  schema_name
                }
                taxons {
                  base_path
                  content_id
                  document_type
                  phase
                  schema_name
                  title
                  links {
                    parent_taxons {
                      base_path
                      content_id
                      document_type
                      phase
                      schema_name
                      title
                    }
                  }
                }
              }
              locale
              schema_name
              title
            }
          }
        }
    QUERY
  end
end
