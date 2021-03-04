# Guide to optimising images for the homepage

Images can cause a significant increase in the download time for the homepage. To prevent this:

 - resize the image to 610 by 407 pixels. This is the largest that the image will be displayed at.
 - if it's a photograph save multiple sizes of the image:
   - 610 by 407 pixels
   - 480 by 320 pixels
   - 320 by 213 pixels
   - 240 by 160 pixels
   - 170 by 113 pixels

Each size should be run the image through an optimiser such as `mozjpeg`.

[Squoosh](https://squoosh.app) allows you to do both image resizing and image optimisation in the browser. You can play with the settings until you get a good result, comparing the optimised image against the original image.

Photographs - as opposed to images with text in them - really benefit from having multiple sizes so the browser can pick which is the best size for the screen size being used. 🚀🌅
