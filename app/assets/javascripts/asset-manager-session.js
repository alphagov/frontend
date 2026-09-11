/* Warms up the Asset Manager draft-assets session before the browser gets a
 * chance to request any of the page's own draft images.
 *
 * Each draft image on a page independently triggers its own Signon/Asset
 * Manager OAuth handshake when there's no existing session. With more than
 * one draft image, these handshakes race and clobber each other's CSRF
 * state, so all but (at best) one image fail to load.
 *
 * This file is inlined verbatim into a single <script> tag in the page
 * <head>, only on draft-stack pages - see _footer_navigation.html.erb. It
 * deliberately isn't shipped as part of the site's main JavaScript bundle,
 * so live pages are completely unaffected and don't load or run any of it.
 * That <script> tag also carries the data-placeholder-asset-url attribute
 * this file reads its configuration from.
 *
 * Plain, self-executing script rather than a GOVUK.Modules-style module:
 * there's nothing here for other code to discover or instantiate, and
 * wrapping a single self-starting instance in a module class would only be
 * indirection for its own sake.
 */
(function () {
  // Captured synchronously, while this script is still the one executing -
  // document.currentScript is only valid during that window, so it can't be
  // read later from inside warmUpSession, which runs on a subsequent 'load'
  // event.
  const scriptElement = document.currentScript

  function draftAssetImages () {
    return [...document.images].filter((image) =>
      image.src.includes('assets.') // currently, asset urls in draft preview point to their live link: 'assets.xyz' instead of 'draft-assets.xyz'. Created a backlog item for this: https://gov-uk.atlassian.net/browse/WHIT-4008.
    )
  }

  function reloadDraftImages (draftAssets) {
    draftAssets.forEach((image) => {
      // re-setting src tries to fetch the image again, with the hope that a prior success is just served from cache
      image.setAttribute('src', image.getAttribute('src'))
    })
  }

  function warmUpSession () {
    const draftAssets = draftAssetImages()
    // fewer than 2 images means there's no concurrent-request race to fix, so nothing to warm up
    if (draftAssets.length < 2) return

    const reload = reloadDraftImages.bind(null, draftAssets)
    const placeholder = new Image()
    placeholder.onload = reload
    placeholder.onerror = reload
    placeholder.src = scriptElement.getAttribute('data-placeholder-asset-url')
  }

  // { once: true } so a fresh execution of this script - such as one run by
  // a test - can't end up with more than one handler responding to a single
  // 'load' event.
  window.addEventListener('load', warmUpSession, { once: true })
})()
