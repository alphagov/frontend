window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function UrlParams (module) {
    this.module = module
    this.getParam = 'utm_campaign'
  }

  UrlParams.prototype.init = function () {
    const thisType = this.module.nodeName
    const params = new URLSearchParams(document.location.search)
    const param = params.get(this.getParam)
    if (!param || thisType !== 'A') {
      return
    }
    const href = this.module.getAttribute('href')
    const url = new URL(href, window.location.origin)
    url.searchParams.set(this.getParam, param) // performs automatic encoding as per encodeURIComponent()
    this.module.setAttribute('href', url.toString())
  }

  Modules.UrlParams = UrlParams
})(window.GOVUK.Modules)
