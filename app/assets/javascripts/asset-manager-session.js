/* Warms up the Asset Manager draft-assets session cookie via a single
 * placeholder image request, then retries any draft images already on
 * the page once that request has settled (success or failure).
 *
 * Usage: add `data-module="AssetManagerSession"` and
 * `data-placeholder-asset-url="..."` to an element.
 */

/* istanbul ignore next */
window.GOVUK = window.GOVUK || {}
/* istanbul ignore next */
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function AssetManagerSession (element) {
    this.element = element
  }

  AssetManagerSession.prototype.init = function () {
    window.addEventListener('load', this.warmUpSession.bind(this))
  }

  AssetManagerSession.prototype.warmUpSession = function () {
    const draftAssets = this.draftAssetImages()
    // fewer than 2 images means there's no concurrent-request race to fix, so nothing to warm up
    if (draftAssets.length < 2) return

    const reloadDraftImages = this.reloadDraftImages.bind(this, draftAssets)
    const placeholder = new Image()
    placeholder.onload = reloadDraftImages
    placeholder.onerror = reloadDraftImages
    placeholder.src = this.element.getAttribute('data-placeholder-asset-url')
  }

  AssetManagerSession.prototype.draftAssetImages = function () {
    return [...document.images].filter((image) =>
      image.src.includes('assets.') // currently, asset urls in draft preview point to their live link: 'assets.xyz' instead of 'draft-assets.xyz'. Created a backlog item for this: https://gov-uk.atlassian.net/browse/WHIT-4008.
    )
  }

  AssetManagerSession.prototype.reloadDraftImages = function (draftAssets) {
    draftAssets.forEach((image) => {
      // re-setting src tries to fetch the image again, with the hope that a prior success is just served from cache
      image.setAttribute('src', image.getAttribute('src'))
    })
  }

  Modules.AssetManagerSession = AssetManagerSession
  // Self-start now instead of waiting for GOVUK.modules.start()
  // on DOMContentLoaded, so the window 'load' listener is registered as early as possible.
  var element = document.querySelector('[data-module="AssetManagerSession"]')
  if (element && !element.getAttribute('data-assetmanagersession-module-started')) {
    new AssetManagerSession(element).init()
    element.setAttribute('data-assetmanagersession-module-started', 'true')
  }
})(window.GOVUK.Modules)