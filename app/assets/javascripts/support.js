/* istanbul ignore next */
if (typeof window.GOVUK === 'undefined') { window.GOVUK = {} }
/* istanbul ignore next */
if (typeof window.GOVUK.support === 'undefined') { window.GOVUK.support = {} }

window.GOVUK.support.history = function () {
  return window.history && window.history.pushState && window.history.replaceState
}
