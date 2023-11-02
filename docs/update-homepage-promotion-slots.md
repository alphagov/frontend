# Update homepage promotion slots

The three promo boxes on the homepage are used to highlight important information on GOV.UK.

![Example image of promotion slots on GOV.UK homepage](images/homepage-promotion-slots.png)

To update these promo boxes, you must edit the underlying HTML template for the homepage.

## 1. Prerequisites

Before updating the promotion slots you must have:

- the URL of the page that is being promoted
- an image that is 160 x 160 pixels
- a title for the promotion (ideally under 25 characters to fit on a single line for most users)
- some contextual text for the promotion (ideally under 80 characters to spread across two lines for most users)

The image should not contain text as [per GOV.UK guidelines](https://www.gov.uk/guidance/content-design/images). Using text within an image creates accessibility problems. For example, the [past homepage promotion slots from March 2020](https://github.com/alphagov/frontend/pull/2292) used text in the images and this approach would now be strongly discouraged.

A custom graphic is strongly recommended for the featured image, given the new dimensions and size, it may be difficult to see the detail in a photograph.

If a photograph is essential, then we should ensure that:

- The photograph follows the prerequisites listed above
- The focus point of the image is clear and fits within the new 1:1 image aspect ratio

## 2. Resize and compress the images

We want the GOV.UK homepage to be optimised towards a fast user experience with a low download size. Central to this is making sure that we serve optimised images. To achieve this, we resize the images and compress the files.

You can use a web tool - [Squoosh](https://squoosh.app/) - to resize and compress the images at the same time. You can use the before and after view to establish the highest level of compression that can be applied before the image quality deteriorates.

Most promo images should ideally be less than 10 kB in size (at time of writing, the current promos are 504 Bytes, 882 Bytes and 512 Bytes). You might also need to change the format of the image to fit the content - JPGs for a photograph, but maybe PNG for a graphic. It's worth testing to see what gives the smaller file size and the best visual result.

The featured images are lazy loaded, but it is worth keeping in mind that for larger screens, the featured images will be requested on page load.

## 3. Update the content

The content for the promo slots can be found in the [`en.yml` translation file](../config/locales/en.yml) (no other locales need to be updated). The specific key to look for is `promotion_slots`. Promo items are stored as a yml list in the order they appear on the homepage. The keys in each list item to update accordingly are:

- `text`: the promo description
- `title`: the promo title
- `href`: the link the promo goes to. This can either be internal (`/my-path`) or external (`https://www.mywebsite.com/my-path`)
- `image_src`: the promo image location. Image should be in the [`homepage` asset directory](https://github.com/alphagov/frontend/tree/main/app/assets/images/homepage) and can be pulled via `homepage/[my-image].png`

## 4. Delete the previous images

You should delete the images that you are replacing from the repository. If we need to use those images again, to perhaps reinstate the promotion later, we can retrieve the images from the Git history.

## 5. Open a pull request

Finally, you should open a pull request. It is helpful to include information on the source of the change request and to provide a screenshot of the updated promotion slots. You should use the screenshot to confirm with stakeholders that they are happy with the change.
