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

    var local_transaction_url = document.location + '.json';

    $.post( local_transaction_url, { lat: AlphaGeo.full_location.current_location.lat, lon: AlphaGeo.full_location.current_location.lon }, function(data) {
      window.console.dir(data.council);
      if (data.council && data.council.name && data.council.url) {
        button.find('a').attr('href', data.council.url);
        button.find('span.destination').text(" on "+ data.council.name +" ");
        button.removeClass('hidden');
      } else {
        $('.no-provider-error').removeClass('hidden').text("Sorry, we couldn't find details of a provider for that service in your area.");
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