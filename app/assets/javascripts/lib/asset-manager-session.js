/* Warms up the Asset Manager draft-assets session cookie via a single
 * placeholder image request, then reloads any draft images already on
 * the page once that request has settled (success or failure).
 */
/* istanbul ignore next */
window.GOVUK = window.GOVUK || {};

(function (root) {
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

  root.GOVUK.warmUpAssetManagerSession = function (placeholderAssetUrl) {
    const draftAssets = draftAssetImages()
    // fewer than 2 images means there's no concurrent-request race to fix, so nothing to warm up
    if (draftAssets.length < 2) return

    const reload = () => reloadDraftImages(draftAssets)
    const placeholder = new Image()
    placeholder.onload = reload
    placeholder.onerror = reload
    placeholder.src = placeholderAssetUrl
  }
}(window))
