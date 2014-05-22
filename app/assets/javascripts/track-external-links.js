(function() {
  "use strict";
  window.GOVUK = window.GOVUK || {};
  var $ = window.jQuery;

  /**
   * TrackExternalLinks
   *
   * Takes either an element which contains a collection of links with a
   * `rel=external` attribute or a single link and adds link tracking to it.
   * The link will then send users through the external link tracker
   * https://github.com/alphagov/external-link-tracker
   **/
  function TrackExternalLinks($el){
    if($el.is('a')){
      $el.on('mousedown keydown', this.track);
    } else {
      $el.on('mousedown keydown', 'a[rel=external]', this.track);
    }
  }
  TrackExternalLinks.prototype.track = function(e){
    var $link = $(e.target),
        linkHref = $link.attr('href');

    if(e.type === 'keydown' && e.keyCode !== 13){ // keyCode 13 = enter key
      // return unless they try and navigate to it
      return true;
    }

    if(linkHref.indexOf('/g?url=') !== 0){
      $link.attr('href', '/g?url=' + window.encodeURIComponent(linkHref));
    }
  };

  GOVUK.TrackExternalLinks = TrackExternalLinks;
}());
