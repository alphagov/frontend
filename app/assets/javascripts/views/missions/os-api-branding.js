// os-api-branding.js v0.3.1

var scriptTag = document.currentScript
window.os = window.os || {}

os.Branding = {
  /**
  * Default configuration options.
  */
  options: {
    div: 'map',
    logo: 'os-logo-maps', // os-logo-maps | os-logo-maps-white
    statement: 'Contains OS data &copy; Crown copyright and database rights YYYY',
    prefix: '',
    suffix: ''
  },

  /**
  * Add the API logo and copyright statement.
  */
  init: function(obj) {
    this.options.div = scriptTag.getAttribute('data-div') || this.options.div
    this.options.logo = scriptTag.getAttribute('data-logo') || this.options.logo
    this.options.statement = scriptTag.getAttribute('data-statement') || this.options.statement
    this.options.prefix = scriptTag.getAttribute('data-prefix') || this.options.prefix
    this.options.suffix = scriptTag.getAttribute('data-suffix') || this.options.suffix

    obj = (typeof obj !== 'undefined') ? obj : {}
    Object.assign(this.options, obj)

    var elem = document.getElementById(this.options.div)

    if(! elem) return

    var logoClassName = 'os-api-branding logo'
    if( this.options.logo === 'os-logo-maps-white' ) {
      logoClassName = 'os-api-branding logo white'
    }

    var copyrightStatement = this.options.statement
    copyrightStatement = copyrightStatement.replace('YYYY', new Date().getFullYear())

    if( this.options.prefix !== '' ) {
      copyrightStatement = this.options.prefix + '<span>|</span>' + copyrightStatement
    }

    if( this.options.suffix !== '' ) {
      copyrightStatement = copyrightStatement + '<span>|</span>' + this.options.suffix
    }

    document.querySelectorAll('#' + this.options.div + ' .os-api-branding').forEach(el => el.remove())

    // Append the API logo.
    var div1 = document.createElement('div')
    div1.className = logoClassName
    elem.appendChild(div1)

    // Append the copyright statement.
    var div2 = document.createElement('div')
    div2.className = 'os-api-branding copyright'
    div2.innerHTML = copyrightStatement
    elem.appendChild(div2)
  }
}

os.Branding.init()