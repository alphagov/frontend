# Update homepage promotion slots

The three promo boxes on the homepage are used to highlight important information on GOV.UK.

![Example image of promotion slots on GOV.UK homepage](images/homepage-promotion-slots.jpg)

To update these promo boxes, you must edit the underlying HTML template for the homepage.

## 1. Prerequisites

Before updating the promotion slots you must have:

- the URL of the page that is being promoted
- an image that is at least 610 x 407 pixels in size in a landscape aspect ratio
- a title for the promotion (ideally under 25 characters to fit on a single line for most users)
- some contextual text for the promotion (ideally under 80 characters to spread across two lines for most users)

The image should not contain text as [per GOV.UK guidelines](https://www.gov.uk/guidance/content-design/images). Using text within an image creates accessibility problems. For example, the [past homepage promotion slots from March 2020](https://github.com/alphagov/frontend/pull/2292) used text in the images and this approach would now be strongly discouraged.

## 2. Resize and compress the images

We want the GOV.UK homepage to be optimised towards a fast user experience with a low download size. Central to this is making sure that we serve optimised images. To achieve this, we resize the images and compress the files.

You can use a web tool - [Squoosh](https://squoosh.app/) - to resize and compress the images at the same time. You can use the before and after view to establish the highest level of compression that can be applied before the image quality deteriorates.

If the image is a photograph, or a detailed graphic, resize the image to all of the following sizes:

- 610 by 407 pixels
- 480 by 320 pixels
- 320 by 213 pixels
- 240 by 160 pixels
- 170 by 113 pixels

If the image is a simple graphic, and thus already a small file size, resize it to 610 x 407 pixels.

## 3. Update the markup and phrases

To apply the change you need to update the [app/views/homepage/_promotion-slots.html.erb](../app/views/homepage/_promotion-slots.html.erb) view by:

- changing the URL and the image paths - make sure you update any corresponding `data-` attributes
- replacing the existing phrases in the [locale file](../config/locales/en.yml)

When updating the image you may need to either add or remove `srcset` attributes for the various image sizes.

The markup for an image that has multiple sizes (such as a photograph) is:

```erb
<%= image_tag "homepage/path-to-610w.jpg", {
  alt: "",
  class: "home-promo__image",
  height: 407,
  loading: "lazy",
  width: 610,
  sizes: "(max-width: 640px) 100vw, (max-width: 1020px) 33vw, 300px",
  srcset: {
    "homepage/path-to-610w.jpg": "610w",
    "homepage/path-to-480w.jpg": "480w",
    "homepage/path-to-320w.jpg": "320w",
    "homepage/path-to-240w.jpg": "240w",
    "homepage/path-to-170w.jpg": "170w",
  },
} %>
```

The markup for an image that has a single size (such as a simple graphic) is:

```erb
<%= image_tag "homepage/path-to-610w.png", {
  alt: "",
  class: "home-promo__image",
  height: 407,
  loading: "lazy",
  width: 610,
} %>
```

## 4. Delete the previous images

You should delete the images that you are replacing from the repository. If we need to use those images again, to perhaps reinstate the promotion later, we can retrieve the images from the Git history.

## 5. Open a pull request

Finally, you should open a pull request. It is helpful to include information on the source of the change request and to provide a screenshot of the updated promotion slots. You should use the screenshot to confirm with stakeholders that they are happy with the change.
