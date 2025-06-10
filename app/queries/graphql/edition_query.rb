class Graphql::EditionQuery
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
              content_id
              description
              details {
                body
                change_history
                default_news_image {
                  alt_text
                  url
                }
                display_date
                emphasised_organisations
                first_public_at
                image {
                  alt_text
                  caption
                  high_resolution_url
                  url
                }
                political
              }
              document_type
              first_published_at
              links {
                available_translations {
                  base_path
                  locale
                }
                document_collections {
                  ...RelatedItem
                  web_url
                }
                government {
                  details {
                    current
                  }
                  title
                }
                mainstream_browse_pages {
                  ...RelatedItem
                }
                ordered_related_items {
                  ...RelatedItem
                }
                ordered_related_items_overrides {
                  ...RelatedItem
                }
                organisations {
                  analytics_identifier
                  base_path
                  content_id
                  title
                }
                people {
                  base_path
                  content_id
                  title
                }
                primary_publishing_organisation {
                  base_path
                  title
                }
                related {
                  ...RelatedItem
                }
                related_guides {
                  ...RelatedItem
                }
                related_mainstream_content {
                  ...RelatedItem
                }
                related_statistical_data_sets {
                  ...RelatedItem
                }
                suggested_ordered_related_items {
                  ...RelatedItem
                }
                taxons {
                  ...Taxon
                  links {
                    parent_taxons {
                      ...Taxon
                      links {
                        parent_taxons {
                          ...Taxon
                          links {
                            parent_taxons {
                              ...Taxon
                              links {
                                parent_taxons {
                                  ...Taxon
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
                topical_events {
                  base_path
                  content_id
                  locale
                  title
                }
                world_locations {
                  analytics_identifier
                  base_path
                  content_id
                  locale
                  title
                }
                worldwide_organisations {
                  analytics_identifier
                  base_path
                  title
                }
              }
              locale
              public_updated_at
              publishing_app
              rendering_app
              schema_name
              title
              updated_at
              withdrawn_notice {
                explanation
                withdrawn_at
              }
            }
          }
        }

        fragment RelatedItem on Edition {
          base_path
          document_type
          locale
          title
        }

        fragment Taxon on Edition {
          base_path
          content_id
          details {
            url_override
          }
          document_type
          locale
          phase
          title
          web_url
        }
    QUERY
  end
end
