# Building blocks for flexible content

The "landing-page" document type will allow content designers to build pages with a flexible design by creating a "block" that renders certain parts of the page.

Blocks can be nested within each other. A top-level block is a horizontal chunk of the page.

Blocks are rendered in the order that they appear in the content item.

## Types of Block

Each block has its own partial template. The full list of available types of block available can be found by looking at the contents of: `app/views/landing_page/blocks`

### Simple blocks

Simple blocks general render one component or "thing". They can either be rendered directly or as the children of compound blocks.

- Action link
- Big number
- Document list
- Govspeak
- Heading
- Image
- Main Navigation
- Quote
- Share links
- Side Navigation
- Statistics
- Tabs

### Compound blocks

Compound blocks generally render more than one component and can contain nested blocks. The nested blocks can be simple blocks or themselves compound blocks

- Card
- Featured
- Hero

#### Layout blocks

- Blocks container
- Columns layout
- Grid Container
- Two column layout


## Indexing block content in search

Only content in blocks that has a label of `content` will be indexed in site search.

```json
{"blocks":
    [
        { 
            "type": "govspeak", 
            "content": "## This will be a searchable header\nhere's some content that's searchable\n"}
        {   
            "type": "button", 
            "text": "Press me (not searchable)"}
        {
            "type": "header", 
            "content": "searchable header"
        }
    ]
}
```

In the example above only the text in the govspeak and header blocks will be searchable.