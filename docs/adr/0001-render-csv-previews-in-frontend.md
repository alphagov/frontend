# Render CSV Previews in Frontend

Date: 2023-06-22

## Context
The Publishing Platform team has been moving migration of public facing pages and end points out of Whitehall for a little over a year and has made its way to CSV previews. These pages differ from most pages in two key ways. Firstly they are served on the assets hostname (assets.publishing.service.gov.uk) and secondly they do not have a content item.

These previews were being served by Whitehall making a request to the asset’s public URL and rendering this in Whitehall Frontend.  Two options were considered for moving these to another application.


### Option 1
There is an RFC that suggests moving these pages to Government Frontend which would involve changing the hostname and creating a content item for these pages. This would be a substantial architectural change, that mostly sits outside the scope of changing the rendering application.

#### Pros
+ Changes the hostname
+ Is arguably a more suitable frontend application

#### Cons
- Changing the hostname is a considerable piece of work
- Will take a long time to get right

### Option 2
Allow a frontend app to communicate directly with Asset Manager and don’t require the changes to the URL or the creation of a content item. This would mean that we couldn’t render CSV previews in Government Frontend because it has a fairly unique way of rendering things that rely on content items existing. Frontend would be a better fit because it follows a traditional MVC architecture.

#### Pros
+ Is relatively quick and straightforward
+ Won't require funky redirect logic to make it work
+ Still allows us to change the hostname in the future

#### Cons
- Doesn't change the hostname

## Decision
Option 2

## Status
Accepted

## Consequences
CSV previews are now rendered by Frontend and we’ve fixed a long standing problem that caused CSV’s attached to draft documents not to be previewable, as Whitehall could not access drafts from the public assets host.

If we decide in the future that we want to make these served by the gov.uk endpoint rather than the assets one then we will have to do an amount of exploratory work that is separated from the immediate issue of moving the rendering.

