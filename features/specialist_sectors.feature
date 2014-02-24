Feature: Browsing specialist sectors
  In order to see all content relating to my specialist interest
  As a user with specialist needs
  I can view content for my sector broken down by topic

  Scenario: viewing documents grouped by content format
    Given there are documents tagged to a specialist sector topic
    When I view the browse page for that topic
    Then I see the documents grouped by document format
      And I don't see headings for formats with no documents
