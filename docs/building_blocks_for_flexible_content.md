# Building blocks for flexible content

The "landing-page" document type will allow content designers to build pages with a flexible design by creating a "block" that renders certain parts of the page.

Blocks can be nested within each other. A top-level block is a horizontal chunk of the page.

Blocks are rendered in the order that they appear in the content item.

Blocks are added to the content item in the `details` hash. The landing page editor is currently a work in progress. At time of writing, the config for blocks need to be added in YAML format in Whitehall. This YAML config is then merged into the `details` hash when the landing page is saved and published.

The YAML config must include a top-level `blocks` element.

```yaml
blocks:
- type: block_type
```

It may optionally include other top-level elements:

* a `breadcrumbs` element, an array of `title/href` pairs which will be used to create a breadcrumb list.
* an `extends` element to inherit configuration from another landing page (See [Extending a page (Whitehall Only)](#extending-a-page-whitehall-only)).
* an `image` element. This has one sub-element (`url`) which should be the url for an image to use with social media metadata.
* a `navigation_groups` element for use by blocks (See [Navigation Groups](#navigation-groups))
* a `theme` element which will set the general appearance of the page. Valid themes are `default` or `prime-ministers-office-10-downing-street`) - if no theme is specified, `default` will be used (See [Themes](#themes))

Block configuration is designed to be as flexible as possible, so blocks can be nested inside other blocks. An example configuration for each type of block is shown below.

## Types of Block

Each block is rendered using its own partial template. The full list of available types of block available can be found by looking at the contents of: `app/views/landing_page/blocks`.

Blocks can be given a full width light grey background by setting `full_width_background: true` in the content item. This will not change the layout of the block itself. Note that sequential blocks given this option will fit together without a gap, because backgrounds are often required on areas of the page consisting of more than one block.

### Simple blocks

Simple blocks generally render one component or "thing". They can either be rendered directly or as the children of compound blocks.

- [Action Link](#action-link)
- [Document List](#document-list)
- [Govspeak](#govspeak)
- [Heading](#heading)
- [Image](#image)
- [Logo](#logo)
- [Main Navigation](#main-navigation)
- [Quote](#quote)
- [Share Links](#share-links)
- [Side Navigation](#side-navigation)

#### Action Link

A wrapper around the [action link component](https://components.publishing.service.gov.uk/component-guide/action_link).

```yaml
- type: action_link
  text: "Learn more about our goals"
  href: "/landing-page/goals"
```

#### Document List

A wrapper around the [Document list component](https://components.publishing.service.gov.uk/component-guide/document_list) with a title that will only appear if there are any items in the list (if the list is entirely empty the heading will not appear either)

The document list can either be populated with the most recent content tagged to a taxon or from a hard-coded list.

If the `taxon_base_path` is provided and the taxon exists and it has content tagged to it, the document list will be populated with that content. If not, it will default to the hard-coded list.

If the `heading` is provided that will be used, otherwise it will default to the hard-coded heading.

```yaml
- type: document_list
  heading: My Favourite Things
  taxon_base_path: /government/government-efficiency-transparency-and-accountability
  items:
  - text: An example link
    path: https://www.gov.uk
    document_type: Press release
    public_updated_at: "2016-06-27 10:29:44 +0000"
  - text: Another example link
    path: https://www.gov.uk
    document_type: News article
    public_updated_at: "2021-01-16 11:34:12 +0000"
  - text: A third example link
    path: https://www.gov.uk
    document_type: Consultation
    public_updated_at: "2024-02-01 09:00:11 +0000"
```

#### Govspeak

A wrapper around the [Govspeak content component](https://components.publishing.service.gov.uk/component-guide/govspeak). Content for this block can be written as [govspeak markdown](https://govspeak-preview.publishing.service.gov.uk/guide) or HTML, depending on how the block is added.

When added to a YAML file within the `frontend` application content must be written in HTML.

```yaml
- type: govspeak
  content: |
    <h3>Lorem heading</h3>
    <p>Korem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis
    molestie, dictum esta, mattis tellus.</p>
```

When added through Whitehall content can either be written in HTML or govspeak markdown, but `content-type` must be specified if using govspeak markdown.

```yaml
- type: govspeak
  content:
    content_type: text/govspeak
    content: |
      ### Lorem heading

      Korem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis
      molestie, dictum esta, mattis tellus.
```

#### Heading

A wrapper around the [Heading component](https://components.publishing.service.gov.uk/component-guide/heading). This block uses `content` where the component uses `text` for the title text key. This is so that headings can appear in search (only values inside a `content` key will be indexed when being published from Whitehall - see [Indexing block content in search](#indexing-block-content-in-search))

If an `id` is added, the heading can be referenced in an anchor link. `heading_level` can be used to specify the heading level (the default is 2) - you should usually have at least one `heading_level: 1` towards the beginning of a page's content. `context` may also be used to add a [context sub-heading](https://components.publishing.service.gov.uk/component-guide/heading#with_context)

```yaml
- type: heading
  id: heading-id
  content: Porem ipsum dolor
  heading_level: 3
```

#### Image

A simple image.

3 versions of the image need to be supplied. This is also true for blocks like [Featured](#featured) and [Hero](#hero) that contain images.

NB: Like [Hero](#hero) if you are adding this block in Whitehall you do not need to manually specify the `_x2` variants.

NB: Unlike [Hero](#hero) this image usually displays 3 different versions of the same image, with the same ratio, so although in Whitehall you have to specify the three tags (desktop, mobile, and tablet), you can usually use the same markdown image tag.

If needed, an optional `theme_colour` integer value can be specified, which gives the image a border top utilising the theme colour you specified.

```yaml
- type: image
  theme_colour: 1
  image:
    alt: "Placeholder alt text"
    sources:
      desktop: "landing_page/placeholder/desktop.png"
      desktop_2x: "landing_page/placeholder/desktop_2x.png"
      mobile: "landing_page/placeholder/mobile.png"
      mobile_2x: "landing_page/placeholder/mobile_2x.png"
      tablet: "landing_page/placeholder/tablet.png"
      tablet_2x: "landing_page/placeholder/tablet_2x.png"
```

#### Logo

A simple logo. Currently this only allows for one logo to be displayed - the NHS logo.

#### Main Navigation

The top-level navigation. It supports multiple headings, each with a row of links. The only supported keys are the `type` key and the `navigation_group_id` key, which should point to an id of a [navigation group](#navigation-groups) to use for the menu items.

```yaml
- type: main_navigation
  navigation_group_id: Top Menu
```

#### Quote

A blockquote.

```yaml
- type: quote
  text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis class"
  cite: "Lorem ipsum dolor sit, 28 September 2024"
```

#### Share Links

A wrapper around a [Heading component](https://components.publishing.service.gov.uk/component-guide/heading) and a [Share links component](https://components.publishing.service.gov.uk/component-guide/share_links).

The heading is hard-coded in the share links view and cannot be configured in the block.

```yaml
- type: share_links
  links:
    - href: /twitter-profile
      text: Twitter
      icon: twitter
      hidden_text: Follow us on
    - href: /instagram-profile
      text: Instagram
      icon: instagram
      hidden_text: Follow us on
    - href: /flickr-profile
      text: Flickr
      icon: flickr
      hidden_text: Follow us on
    - href: /facebook-profile
      text: Facebook
      icon: facebook
      hidden_text: Follow us on
    - href: /youtube-profile
      text: YouTube
      icon: youtube
      hidden_text: Follow us on
```

#### Side Navigation

A navigation item suitable for use in a sidebar. It supports a single column of links. The only supported keys are the `type` key and the `navigation_group_id` key, which should point to an id of a [navigation group](#navigation-groups) to use for the menu items.

```yaml
- type: side_navigation
  navigation_group_id: Sidebar
```

### Compound blocks

Compound blocks generally render more than one component and can contain nested blocks. The nested blocks can be simple blocks or themselves compound blocks

- [Box](#box)
- [Card](#card)
- [Featured](#featured)
- [Hero](#hero)

#### Box

A box block renders its `content` value as a [Heading component](https://components.publishing.service.gov.uk/component-guide/heading). If an `href:` is specified, the heading will link to that location. Subblocks are laid out vertically beneath the heading.

Box blocks have a light grey background and can be styled with a predefined top border for colour-coded content using the `theme_colour` property.

```yaml
- type: box
  content: This is a heading
  href: https://www.gov.uk
  theme_colour: 1
  box_content:
    blocks:
      - type: govspeak
        content: |
          <p>Yorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis class.</p>
```

#### Card

A card block renders its `card_content` value as a [Heading component](https://components.publishing.service.gov.uk/component-guide/heading), followed by the subblocks laid out vertically, followed by an image (if specified - at time of writing the image in the card block can not be taken from the content item and must be present in frontend).

```yaml
- type: card
  card_content:
    blocks:
    - type: heading
      content: Rorem ipsum dolor sit amet, consectetur adipiscing elit.
      path: http://gov.uk
```

#### Featured

A featured block renders either a vertical column of blocks on the left of a large (but not full-width) image (it uses a picture element to allow multiple image versions for different devices) or a block of text without an image. The latter can be rendered by omitting the `image` value as demonstrated in the second example below.

```yaml
- type: featured
  image:
    alt: example alt text
    sources:
      desktop: "landing_page/placeholder/desktop.png"
      desktop_2x: "landing_page/placeholder/desktop_2x.png"
      mobile: "landing_page/placeholder/mobile.png"
      mobile_2x: "landing_page/placeholder/mobile_2x.png"
      tablet: "landing_page/placeholder/tablet.png"
      tablet_2x: "landing_page/placeholder/tablet_2x.png"
  featured_content:
    blocks:
      - type: heading
        content: Our tasks
      - type: govspeak
        content: |
          <p>Lorem ipsum dolor sit amet. In voluptas dolorum vel veniam nisi et voluptate dolores id voluptatem distinctio. Et quia accusantium At ducimus quis aut voluptates iusto aut esse suscipit.</p>
```

```yaml
- type: featured
  featured_content:
    blocks:
      - type: heading
        content: Our tasks
      - type: govspeak
        content: |
          <p>Lorem ipsum dolor sit amet. In voluptas dolorum vel veniam nisi et voluptate dolores id voluptatem distinctio. Et quia accusantium At ducimus quis aut voluptates iusto aut esse suscipit.</p>
```

#### Hero

A hero block displays a full screen width image with an optional text box, that can contain further blocks.

The text box will be two thirds width (default, intended for use at the top of a page) or one third for use part way down a page (configured using `theme: middle_left`).

Like the featured block, it uses a picture element to allow multiple image versions for different devices.

As hero images are intended to be decorative, it's not possible to configure them with alt text.

##### Structure

The YAML structure for hero images is slightly different depending on whether the content item is in Content Store (or a hardcoded YAML block which has to match the Content Store format), or in Whitehall.

In content store or when hardcoded, the block should look like this:

```yaml
- type: hero
  image:
    sources:
      desktop: "landing_page/placeholder/desktop.png"
      desktop_2x: "landing_page/placeholder/desktop_2x.png"
      mobile: "landing_page/placeholder/mobile.png"
      mobile_2x: "landing_page/placeholder/mobile_2x.png"
      tablet: "landing_page/placeholder/tablet.png"
      tablet_2x: "landing_page/placeholder/tablet_2x.png"
  hero_content:
    blocks:
      - type: heading
        content: Rorem ipsum dolor sit
```

When authored in Whitehall, uploaded images should be referred to using markdown syntax.

```yaml
- type: hero
  image:
    sources:
      desktop: "[Image: desktop.png]"
      mobile: "[Image: mobile.png]"
      tablet: "[Image: tablet.png]"
  hero_content:
    blocks:
      - type: heading
        content: Rorem ipsum dolor sit
```

Whitehall will automatically create separate `_2x` images for high density screens.

Note that the `[Image: desktop.png]` syntax must be wrapped in quotes (`"[Image: desktop.png]"`) to ensure that YAML treats it as a string and not an array.

### Layout blocks

Layout blocks are similar to compound blocks in that they contain nested blocks. They are used to arrange blocks on the page, and to make it easier to apply styling to the blocks.

- [Blocks Container](#blocks-container)
- [Columns Layout](#columns-layout)
- [Two Column Layout](#two-column-layout)

#### Blocks Container

A blocks container is used as an empty unstyled parent container to hold other elements. It is used when we don't want to want to create a row/grid layout to contain nested blocks. It is for situations where the grids and columns have already been defined, and you are nesting other blocks within them (see second example).

It does nothing except contain other blocks and is only required as the top level element within columns created by two column layouts. Without a blocks container, there’s no way to add more than one sub-block in the column or arrange blocks on top of each other in a single column.

```yaml
- type: blocks_container
  blocks:
  - type: govspeak
    content: |
      <p>Korem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum esta, mattis tellus.</p>
```

Nested blocks container:

```yaml
- type: two_column_layout
  theme: one_third_two_thirds
  blocks:
  - type: govspeak
    content: <p>Left content!</p>
  - type: blocks_container
    blocks:
      - type: govspeak
        content: |
          <h2>This is a heading</h2>
          <p>Lorem ipsum...</p>
      - type: action_link
        text: "See the missions"
        href: "todo"
```
This example uses the `blocks_container` for the element type in the second [two-thirds width column](#two-column-layout). Without this empty unstyled container we'd have no way of inserting multiple different blocks in the column.

#### Columns Layout

Columns layout spreads its blocks out horizontally. The `columns` property determines how many columns will be in each row, and can accept the following values:

- `columns: 2` Two columns, each taking up half of the available space.
- `columns: 3` Three columns, each taking up one-third of the available space.
- any other value for `columns` will have no effect: all child elements will render the full width of this container.

If `columns` is missing entirely, three columns will be rendered by default.

In the following example, the first two `govspeak` blocks will be side-by-side on the first row and the third block will drop down onto the next row, taking up the left hand column.

```yaml
- type: columns_layout
  columns: 2
  blocks:
  - type: govspeak
    content: |
      <p>Lorem ipsum...</p>
  - type: govspeak
    content: |
      <p>Lorem ipsum...</p>
  - type: govspeak
    content: |
      <p>Lorem ipsum...</p>
```

#### Two Column Layout

A two column layout takes one or two blocks and a theme to determine the column layout. These options are:

- `one_third_two_thirds`
- `two_thirds_one_third`
- `two_thirds_right` - provides the same layout as `one_third_two_thirds` but content for the left column is not required

Theme: one third / two thirds

```yaml
- type: two_column_layout
  theme: one_third_two_thirds
  blocks:
  - type: side_navigation
    navigation_group_id: Sidebar
  - type: blocks_container
    blocks:
    - type: govspeak
      content: |
        <p>This content will be in a two thirds column.</p>
```

Theme: two thirds / one third (note that content is not required for the one third column)

```yaml
- type: two_column_layout
  theme: two_thirds_one_third
  blocks:
  - type: blocks_container
    blocks:
    - type: govspeak
      content: |
        <p>This content will be in a two thirds column.</p>
  - type: govspeak
      content: |
        <p>This content will be in a one third column.</p>
```

Theme: two thirds right

```yaml
- type: two_column_layout
  theme: two_thirds_right
  blocks:
  - type: blocks_container
    blocks:
    - type: govspeak
      content: |
        <p>This content will be in a two thirds column, offset one third from the left of the page.</p>
```

## Indexing block content in search

Only content in blocks that have a label of `content` will be indexed in site search.

```yaml
blocks:
- type: govspeak
  content: |
    ## This will be a searchable header
    here's some content that's searchable
- type: button
  text: Press me (not searchable)
- type: header
  content: searchable header
```

In the example above only the text in the govspeak and header blocks will be searchable.

### Utility blocks

Utility blocks exist to support development. They will not render on the published view of the page, although they may render on the draft view of pages.

- [Block Error](#block-error)

#### Block Error

This is a special type of block that handles errors in other blocks. If a block raises an error during initialization, the block factory will turn it into an error block. This will only render in draft view, where it will display the error in place. It will not show on the live site.

## Navigation Groups

The top-level key `navigation_groups` contains an array of items with the keys `id`, `name` and `links`. The id is used to identify the group for navigation blocks like [main navigation](#main-navigation) and [side navigation](#side-navigation), which reference a navigation group with their `navigation_group_id` key. The `name` key is used for the main button text (if the navigation collapses behind a button). The `links` key contains an array of `text` keys. These `text` keys represent headings that are rendered on the navigation element. These `text` values also contain a child `links` item, with `links` being an array of links related to that heading.

```yaml
navigation_groups:
- id: Top Menu
  name: Name for the main menu button
  links:
  - text: First heading
    links:
    - text: Landing page
      href: /landing-page/homepage/
    - text: Another link
      href: /landing-page/example/
  - text: Second heading
    links:
    - text: Goal 1
      href: /goal-1
    - text: Goal 2
      href: /goal-2
```

## Themes

There are two types of `theme` key. If theme appears at the top-level, it affects the structure and layout of the whole page, and must be on the list below. Some blocks have their own themes, which have their own set of valid values and only affect that component. These two types of `theme` key work independently.

### Valid top-level themes:

* `default` (or no theme specified): a general-purpose page, with the gov.uk header and footer.
* `prime-ministers-office-10-downing-street`: similar to default, but has a dark background/inverted text for the breadcrumbs, and an inverted version of the No. 10 header, with the crest of the Prime Minister's office.

## Extending a page (Whitehall Only)

When editing a page in Whitehall, you may wish to use data from another flexible content page. Adding the top-level key `extends`, and the path of another landing page, will cause the data from the current block to be merged over the data from the extended block before publishing. This is a shallow merge (ie only top-level values are checked), and is currently used so that navigation groups can be specified in one page and used by sub-pages.

If you have a homepage (at /landing-page/homepage) like this:

```yaml
navigation_groups:
- id: Top Menu
  links:
  - text: Homepage
    href: /landing-page/homepage
  - text: Child 1
    href: /landing-page/child
  - (etc)
blocks:
- type: main_navigation
  navigation_group_id: Top Menu
- type: govspeak
  content: <p>Hello!</p>
```

and a child page (at /landing-page/child) like this:

```yaml
extends: /landing-page/homepage
blocks:
- type: main_navigation
  navigation_group_id: Top Menu
- type: govspeak
  content: <p>Hello from the child!</p>
```

...the navigation_groups element will be copied into the child page when it is saved (allowing you to specify a shared menu in one page and simply [republish all the child pages](#republishing-all-landing-pages) in Whitehall).

The extends keyword copies over everything from the parent to the child. It then replaces parent elements with what's in the child if a duplicate top-level element exists in the child. For example, if the child page didn't specify any blocks, those too would be copied over from the parent. That's because `extends` does a shallow merge of everything in the `details` element of the parent. This means that it is possible to add more top-level elements that can be shared across child pages.

The merging of elements is only visible in the content item. In the Whitehall editor you'll still only see the `extends` keyword, but in the content item the `navigation_groups` would be expanded on all child pages as well as the parent:

```json
"navigation_groups": [
  {
    "id": "Top Menu",
    "links": [
      {
        "href": "/homepage",
        "text": "Home page"
      },
      {
        "href": "/goals",
        "text": "Goals"
      },
      {
        "href": "/tasks",
        "text": "Tasks"
      }
    ]
  }
]
```

### Republishing all Landing Pages

If a `navigation_group` is modified on a parent page, all of the child pages will need to be republished to pick up the changes.

Whitehall has a UI to help you do this.

1. Go to "More" in menu (top right)
2. Click on "Republish content"
3. Scroll down to "Bulk republishing"
4. Scroll to "All by type" and click "Republish"
5. Select "LandingPage" from the drop-down and click "Continue"
6. Provide a reason for the republish and click "Confirm republishing"
7. You should see a Success message with "All by type 'LandingPage' have been queued for republishing"

As a last ditch option there is also a [rake task](https://github.com/alphagov/whitehall/blob/ab6322aeca5011ad58210961400950c011daf750/lib/tasks/publishing_api.rake#L189) that does the same thing:

```ruby
rake publishing_api:document_type["LandingPage"]
```
