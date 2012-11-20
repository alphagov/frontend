module BrowseHelper
  # There's at least one case where we need to include an Inside Government
  # item in a mainstream browse page. This helper takes a sub section and
  # returns an array of items to insert at the top of the list.
  def hardcoded_results(sub_section)
    [].tap do |results|
      if tag_id(sub_section) == "citizenship/government"
        results << {
          title: 'How government works',
          link: '/government/how-government-works',
          description: 'About the UK system of government. Understand who runs government, and how government is run'
        }
      end
    end  
  end

  # Extract the tag_id from the ID of the item returned by the content API.
  # Ideally we'd compare the URLs as they're the proper ID for a tag, but
  # that varies across environments whereas the more minimal ID doesn't so
  # is easier to test.
  def tag_id(section)
    encoded_id = URI.parse(section.id).path.gsub(/\/tags\/(.*).json/, "\\1")
    CGI.unescape(encoded_id)
  end
end