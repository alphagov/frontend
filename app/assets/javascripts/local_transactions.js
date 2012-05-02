/*
Local transactions loading
*/

var setup_local_transactions = function() {

  $(AlphaGeo).bind('location-completed', function(location) {
    load_transaction();
  });
  $(AlphaGeo).bind('location-removed', function(location) {
    $('.location-placeholder').text('');
    unload_transaction();
  });

  var form = new AlphaGeoForm('#local-locator-form');
  var button = $('.get-started');

  function load_transaction() {
    $('.no-provider-error').addClass('hidden');

    $('.location-placeholder').text(AlphaGeo.full_location.current_location.councils[0].name);
    $('#location-loading').removeClass('hidden');

    var params = { 
      lat: AlphaGeo.full_location.current_location.lat, 
      lon: AlphaGeo.full_location.current_location.lon
    };
    if (AlphaGeo.full_location.current_location.council) {
      params.council_ons_codes = $.map(AlphaGeo.full_location.current_location.council, function(c) {return c.ons});
    }
    var local_transaction_url = document.location + '.json';
    $.post( local_transaction_url, params, function(data) {
      if (data.council && data.council.name && data.council.url) {
        button.find('a').attr('href', data.council.url);
        button.find('span.destination').text(" on the "+ data.council.name +" website");
        button.removeClass('hidden');
      } else if(data.council && data.council.name && data.council.contact_address) {
        var message = '<div class="contact"><p>';
        message += '<p>This service is provided by <a href="' + data.council.contact_url + '">' + data.council.name + '</a>.</p>';
        // we don't know what the various address parts are
        for (var i = 0, l = data.council.contact_address.length; i < l; i++) {
          message += data.council.contact_address[i] + '<br>';
        }
        message += '<br />';
        message += '<strong>Telephone:</strong> ' + data.council.contact_phone + '<br>';
        message += '</p></div>';


        $('.no-provider-error').removeClass('error-notification').removeClass('hidden').html(message)
        $('input[name=postcode]').attr('aria-labelledby', 'extendedLabel');
      } else {
        var message = "Sorry, we couldn't find details of a provider for that service in your area.";
        $('.no-provider-error').removeClass('hidden').addClass('error-notification').text(message);
        $('input[name=postcode]').attr('aria-labelledby', 'extendedLabel');
      }
      $('#location-loading').addClass('hidden');
    });
  }
  function unload_transaction() {
    $('.no-provider-error').addClass('hidden');
    button.addClass('hidden');
  }
}

$( function() {
  if ( $('#wrapper').attr('class').match(/local_transaction/) ) {
    setup_local_transactions();
  }
});