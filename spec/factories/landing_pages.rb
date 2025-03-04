FactoryBot.define do
  factory :landing_page, class: LandingPage, parent: :content_item do
    base_path { "/landing-page/test" }
    schema_name { "landing_page" }
    details { { blocks: [] } }

    initialize_with { new(attributes.deep_stringify_keys) }

    factory :landing_page_with_navigation_groups do
      details do
        {
          blocks: [],
          navigation_groups: [
            {
              id: "Top Menu",
              name: "Some navigation group name",
              links: [
                { href: "https://www.gov.uk", text: "Service Name" },
                { href: "/hello", text: "Test 1" },
                {
                  href: "/goodbye",
                  text: "Test 2",
                  links: [
                    { href: "/a", text: "Child a" },
                    { href: "/b", text: "Child b" },
                  ],
                },
              ],
            },
            {
              id: "Submenu",
              links: [
                { href: "/a", text: "Child a" },
                { href: "/b", text: "Child b" },
              ],
            },
          ],
        }
      end
    end
  end
end
