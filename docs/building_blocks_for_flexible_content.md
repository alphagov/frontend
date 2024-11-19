# Building blocks for flexible content

The "landing-page" document type will allow content designers to build pages with a flexible design by creating a "block" that renders certain parts of the page.

Blocks can be nested within each other. A top-level block is a horizontal chunk of the page.

Blocks are rendered in the order that they appear in the content item.

Blocks are added to the content item in the `details` hash. The landing page editor is currently a work in progress. At time of writing, the config for blocks need to be added in YAML format in Whitehall. This YAML config is then merged into the `details` hash when the landing page is saved and published.

The YAML config must include a top-level `blocks` element. e.g.

```yaml
blocks:
- type: block_type
```

...and may include a top-level `navigation_groups` element for use by blocks (See [Navigation Groups](#navigation-groups)), or a top-level `extends` element to inherit configuration from another landing page (See [Extending a page (Whitehall Only)](#extending-a-page-whitehall-only)).

Block configuration is designed to be as flexible as possible, so blocks can be nested inside other blocks. An example configuration for each type of block is shown below.

## Types of Block

Each block is rendered using its own partial template. The full list of available types of block available can be found by looking at the contents of: `app/views/landing_page/blocks`

### Simple blocks

Simple blocks generally render one component or "thing". They can either be rendered directly or as the children of compound blocks.

- [Action link](#action-link)
- [Big number](#big-number)
- [Document list](#document-list)
- [Govspeak](#govspeak)
- [Heading](#heading)
- [Image](#image)
- [Main Navigation](#main-navigation)
- [Quote](#quote)
- [Share links](#share-links)
- [Side Navigation](#side-navigation)
- [Statistics](#statistics)

#### Action link

A wrapper around the [action link component](https://components.publishing.service.gov.uk/component-guide/action_link).

##### Example

```yaml
- type: action_link
  text: "Learn more about our goals"
  href: "/landing-page/goals"
```

#### Big number

A wrapper around the [Big number component](https://components.publishing.service.gov.uk/component-guide/big_number)

##### Example

```yaml
- type: big_number
  number: £75m
  label: amount of money that looks big
```

#### Document list

A wrapper around the [Document list component](https://components.publishing.service.gov.uk/component-guide/document_list)

##### Example

```yaml
- type: document_list
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

A wrapper around the [Govspeak content component](https://components.publishing.service.gov.uk/component-guide/govspeak). 

Content for this block can either be written as [govspeak](https://govspeak-preview.publishing.service.gov.uk/guide) or HTML. If you are adding a Govspeak block in config in the `frontend` application, it must be added as HTML. This is because, despite the name, the Govspeak component it calls actually renders HTML content.

If you are adding the block in config in Whitehall you have a choice of writing it in either govspeak or HTML. That is because govspeak content added in Whitehall is automatically converted to HTML by publishing-api. However, if you use govspeak, you'll need to supply the `content-type` (see second example).

##### Examples

```yaml
- type: govspeak
  content: |
    <h3>Lorem heading</h3>
    <p>Korem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis
    molestie, dictum esta, mattis tellus.</p>
```

```yaml
- type: govspeak
  content:
    content-type: text/govspeak
    content: |
      ### Lorem heading

      Korem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis
      molestie, dictum esta, mattis tellus.
```

#### Heading

A wrapper around the [Heading component](https://components.publishing.service.gov.uk/component-guide/heading). Note, though, that the block uses `content` where the component uses `text` for the title text key. This is so that headings can appear in search (only values inside a `content` key will be indexed when being published from Whitehall - see [Indexing block content in search](#indexing-block-content-in-search))

##### Example

```yaml
- type: heading
  content: Porem ipsum dolor
```

#### Image

A simple image.

6 versions of the image need to be supplied. This is also true for blocks like [Featured](#featured) and [Hero](#hero) that contain images.

##### Example

```yaml
- type:
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

#### Main Navigation

The landing-page top-level navigation. It supports a row of links, and sub-menus that will only appear on mobile (where the entire menu is compressed into a single drop-down). The only supported keys are the `type` key and the `navigation_group_id` key, which should point to an id of a [navigation group](#navigation-groups) to use for the menu items. Note that the styling of the first link is different, and it is assumed to be the homepage in a group of landing pages.

##### Example

```yaml
- type: main_navigation
  navigation_group_id: Top Menu
```

#### Quote

A blockquote.

##### Example

```yaml
- type: quote
  text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis class"
  cite: "Lorem ipsum dolor sit, 28 September 2024"
```

#### Share links

A wrapper around a [Heading component](https://components.publishing.service.gov.uk/component-guide/heading) followed by a [Share links component](https://components.publishing.service.gov.uk/component-guide/share_links)

Currently the heading is hard-coded in the share links view and cannot be configured in the block.

##### Example

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

##### Example

```yaml
- type: side_navigation
  navigation_group_id: Sidebar
```

#### Statistics

A wrapper around the [Chart](https://components.publishing.service.gov.uk/component-guide/chart) component. The `csv_file` key can be an uploaded file (from /lib/data/landing_page_content_items/statistics), or (preferably) an attachment from the content item, in which case the filename of the attachment will be matched to the `csv_file` key.

##### Example

```yaml
- type: statistics
  title: "Chart to visually represent data"
  x_axis_label: "X Axis"
  y_axis_label: "Y Axis"
  csv_file: "data_one.csv"
  data_source_link: https://www.ons.gov.uk/economy/grossdomesticproductgdp/timeseries/ihyq/qna
```

Extra options:

For a "minimal" chart add "minimal" attributes the block config

```yaml
- type: statistics
  title: "Chart to visually represent data"
  x_axis_label: "X Axis"
  y_axis_label: "Y Axis"
  csv_file: "data_one.csv"
  data_source_link: https://www.ons.gov.uk/economy/grossdomesticproductgdp/timeseries/ihyq/qna
  minimal: true
  minimal_link: /landing-page/task
```

### Compound blocks

Compound blocks generally render more than one component and can contain nested blocks. The nested blocks can be simple blocks or themselves compound blocks

- [Card](#card)
- [Featured](#featured)
- [Hero](#hero)

#### Card

A card block renders its `card_content:` value as a [Heading component](https://components.publishing.service.gov.uk/component-guide/heading), followed by the subblocks laid out vertically, followed by an image (if specified - at time of writing the image in the card block can not be taken from the content item and must be present in frontend).

##### Example

```yaml
- type: card
  card_content:
    blocks:
    - type: heading
      content: Rorem ipsum dolor sit amet, consectetur adipiscing elit.
      path: http://gov.uk
    - type: statistics
      x_axis_label: "X Axis"
      y_axis_label: "Y Axis"
      csv_file: "data_one.csv"
      data_source_link: https://www.ons.gov.uk/economy/grossdomesticproductgdp/timeseries/ihyq/qna
```

#### Featured

A featured block renders a vertical column of blocks on the left of a large (but not full-width) image. It uses a picture element to allow multiple image versions for different devices.

##### Example

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
        path: /landing-page/tasks
      - type: govspeak
        content: |
          <p>Lorem ipsum dolor sit amet. In voluptas dolorum vel veniam nisi et voluptate dolores id voluptatem distinctio. Et quia accusantium At ducimus quis aut voluptates iusto aut esse suscipit.</p>
```

#### Hero

A hero block renders a vertical column of blocks in a two-thirds-width block on the lower-left of a full-width image. Like the featured block, it uses a picture element to allow multiple image versions for different devices.

As hero images are intended to be decorative, it's not possible to configure them with alt text.

##### Example

The YAML structure for hero images is slightly different depending on whether you're looking at the content item in Content Store (or a hardcoded YAML block which has to match the Content Store format), or in Whitehall.

In content store / when hardcoded, the block should look like this:

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

When authored in Whitehall, you should upload the images and then refer to them using their markdown syntax as follows:

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

Note that you don't need to provide separate `_2x` resolutions in Whitehall, as it will do this automatically.

Also note that you must wrap the `[Image: desktop.png]` syntax in quotes (`"[Image: desktop.png]"`) to ensure that YAML treats it as a string and not an array.

### Layout blocks

Layout blocks are similar to compound blocks in that they contain nested blocks. They are used to arrange blocks on the page, and to make it easier to apply styling to the blocks.

- [Blocks container](#blocks-container)
- [Columns layout](#columns-layout)
- [Grid Container](#grid-container)
- [Two column layout](#two-column-layout)

#### Blocks container

A blocks container is used as an empty unstyled parent container to
hold other elements. It is used when we don't want to want to create a row/grid layout to contain nested blocks. It is for situations where the grids and columns have already been defined, and you are nesting other blocks within them. (See second example)

It does nothing except contain other blocks and is only required as the top level element within columns created by two column layouts. Without a blocks container, there’s no way to add more than one sub-block in the column or arrange blocks on top of each other in a single column.

##### Example

```yaml
- type: blocks_container
  blocks:
  - type: govspeak
    content: |
      <p>Korem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum esta, mattis tellus.</p>
  - type: statistics
    title: "Chart to visually represent data"
    x_axis_label: "X Axis"
    y_axis_label: "Y Axis"
    csv_file: "data_one.csv"
    data_source_link: https://www.ons.gov.uk/economy/grossdomesticproductgdp/timeseries/ihyq/qna
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

#### Columns layout

Columns layout spreads its blocks out horizontally. Depending on the number of child blocks, each column will take all (1 block), 1/2 (2 blocks), 1/3 (3 blocks), or 1/4 (4 or more blocks) of the width. If there are more than 4 blocks, blocks will wrap around after every fourth block.

##### Example

```yaml
- type: columns_layout
  blocks:
  - type: big_number
    number: £75m
    label: amount of money that looks big
  - type: big_number
    number: 100%
    label: increase in the number of big_number components added to the columns at this point
  - type: big_number
    number: £43
    label: Cost of a cup of coffee in Covent Garden
```

#### Grid Container

Like the blocks container, but uses `display: flex` to lay out the child blocks.

The grid container automatically arranges blocks into their own columns, independently of using the design system’s row/columns approach. These new columns are equally sized and spaced to a maximum of three. If more than three, a second row is started. It was created to give us control of the three columns of charts on the landing page homepage, but could be used to arrange other content into columns too.

Note: The grid container was developed specifically to be used with card blocks and has not been tested with other block types. It was necessary when the design had cards that had three elements: Title, body text, chart. The grid container was required to get all the charts to line up regardless of how much body text was in the card. It may be possible to remove this block as there is no longer a requirement for body text. 

##### Example

```yaml
- type: grid_container
  blocks:
  - type: card
    card_content:
      blocks:
        - type: heading
          content: Korem ipsum dolor sit
          path: /landing-page/task
        - type: statistics
          title: "Chart to visually represent some data"
          x_axis_label: "X Axis"
          y_axis_label: "Y Axis"
          csv_file: "data_one.csv"
          data_source_link: https://www.ons.gov.uk/economy/grossdomesticproductgdp/timeseries/ihyq/qna
          minimal: true
          minimal_link: /landing-page/task
  - type: card
    card_content:
      blocks:
        - type: heading
          content: Korem ipsum dolor sit
          path: /landing-page/task
        - type: statistics
          title: "Chart to visually represent some data"
          x_axis_label: "X Axis"
          y_axis_label: "Y Axis"
          csv_file: "data_one.csv"
          data_source_link: https://www.ons.gov.uk/economy/grossdomesticproductgdp/timeseries/ihyq/qna
          minimal: true
          minimal_link: /landing-page/task
  - type: card
    card_content:
      blocks:
        - type: heading
          content: Korem ipsum dolor sit
          path: /landing-page/task
        - type: statistics
          title: "Chart to visually represent some data"
          x_axis_label: "X Axis"
          y_axis_label: "Y Axis"
          csv_file: "data_one.csv"
          data_source_link: https://www.ons.gov.uk/economy/grossdomesticproductgdp/timeseries/ihyq/qna
          minimal: true
          minimal_link: /landing-page/task
```

#### Two column layout

A two column layout takes one or two blocks, and depending on the theme (`one_third_two_thirds` or `two_thirds_one_third`), it lays them out horizontally with the first (left) or second (right) block getting twice the width of the other.

##### Example

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
        <p>Korem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis
        molestie, dictum esta, mattis tellus.</p>
    - type: statistics
      title: "Chart to visually represent data"
      x_axis_label: "X Axis"
      y_axis_label: "Y Axis"
      csv_file: "data_one.csv"
      data_source_link: https://www.ons.gov.uk/economy/grossdomesticproductgdp/timeseries/ihyq/qna
    - type: govspeak
      content: |
        <p>Korem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis
        molestie, dictum esta, mattis tellus.</p>
```

Theme: two thirds / one third

```yaml
- type: two_column_layout
  theme: two_thirds_one_third
  blocks:
  - type: blocks_container
    blocks:
    - type: govspeak
      content: |
        <p>Korem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus.</p>
    - type: heading
      content: "Title of content"
    - type: image
      theme: full_width
      src: "landing_page/placeholder/960x640.png"
      alt: "Placeholder image"
    - type: govspeak
      content: |
        <p>Korem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus.</p>
```

The left column is always populated if only one column is defined.
A blocks container applied to a column so that everything in the column can be styled relative to one and other.

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

## Navigation Groups

The top-level key `navigation_groups` contains an array of items with the keys `id` and `links`. The id is used to identify the group for navigation blocks like [main navigation](#main-navigation) and [side navigation](#side-navigation), which reference a navigation group with their `navigation_group_id` key. The links key is an array of `text`/`href` values, although a links item can itself contain a `links` key pointing to an array of links for a submenu (main navigation supports sub menus, side navigation does not)

```yaml
navigation_groups:
- id: Top Menu
  links:
  - text: Goals
    href: /landing-page/goals
  - text: Tasks
    href: /landing-page/tasks
    links:
      - text: Be kinder
        href: "/landing-page/be-kinder"
      - text: Exercise more
        href: "/landing-page/exercise-more"
      - text: Donate to charity
        href: "/landing-page/donate-to-charity"
      - text: Learn something new
        href: "/landing-page/learn-something-new"
      - text: Be thankful
        href: "/landing-page/be-thankful"
```

## Extending a page (Whitehall Only)

When editing a page in Whitehall, you may wish to use data from another flexible content page. Adding the top-level key `extends`, and the path of another landing page, will cause the data from the current block to be merged over the data from the extended block before publishing. This is a shallow merge (ie only top-level values are checked), and is currently used so that navigation groups can be specified in one page and used by sub-pages.

### Example

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

...the navigation_groups element will be copied into the child page when it is saved (allowing you to specify a shared menu in one page and simply republish all the child pages with a standard Whitehall rake task).

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
If a `navigation_group` is modified on a parent page, all of the child pages will need to be republished to pick up the changes. There is a [rake task](https://github.com/alphagov/whitehall/blob/ab6322aeca5011ad58210961400950c011daf750/lib/tasks/publishing_api.rake#L189) in Whitehall to aid with this:

```ruby
rake publishing_api:document_type["LandingPage"]
```
