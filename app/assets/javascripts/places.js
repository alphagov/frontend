/*
Places (Find my nearest)
*/

var setup_places = function() {
  var form = new AlphaGeoForm('#local-locator-form');

  var load_new_locations = function() {
    $('.further_information').hide();
    $('#options-loading').removeClass('hidden');
    $.ajax({
      url: (document.location + '.json').replace(/\/\.json$/, '.json'),
      dataType: 'json',
      data: {
        lat: AlphaGeo.full_location.current_location.lat,
        lon: AlphaGeo.full_location.current_location.lon
      },
      type: 'POST',
      success: function (data) {
        $('#options-loading').addClass('hidden');

        if (data.places.length > 0) {
          $('h3#options-header').show().removeClass('hidden');
          $('#options').html($.mustache($('#option-template').html(), {options: data.places}));
        } else {
          $('#results-error').removeClass('hidden').find('p').text('Sorry, no results were found near you.');
        }
        _gaq.push(['_trackEvent', 'Citizen-Format-Findmynearest', 'Success-results']);
        $('#options-header').show();
      }
    });
  }

  var remove_existing_location_data = function() {
    $("#options").html('');
    $('#options-header').hide();
    $('#results-error').addClass('hidden');
  }

  $(AlphaGeo).bind('location-removed', function(e, message) {
    remove_existing_location_data();
    $('.further_information').show();
  });

  $(AlphaGeo).bind('location-completed', function(e, location) {
    remove_existing_location_data();
    $('strong.locality_placeholder').text(AlphaGeo.full_location.current_location.locality);
    load_new_locations();
  });
}

$( function() {
  if ( $('#wrapper').attr('class').match(/place/) ) {
    setup_places();
  }
});