// /*
// Local transactions loading
// */

// var setup_local_transactions = function() {

//   $(AlphaGeo).bind('location-completed', function(location) {
//     load_transaction();
//   });
//   $(AlphaGeo).bind('location-removed', function(location) {
//     $('.location-placeholder').text('');
//     unload_transaction();
//   });

//   var form = new AlphaGeoForm('#local-locator-form');
//   var button = $('.get-started');

//   function load_transaction() {
//     $('#no-provider-error').addClass('hidden');
//     $('#authority-contact').addClass("hidden");

//     $('.location-placeholder').text(AlphaGeo.full_location.current_location.councils[0].name);
//     $('#location-loading').removeClass('hidden');

//     var params = {
//       lat: AlphaGeo.full_location.current_location.lat,
//       lon: AlphaGeo.full_location.current_location.lon
//     };
//     if (AlphaGeo.full_location.current_location.council) {
//       params.council_ons_codes = $.map(AlphaGeo.full_location.current_location.council, function(c) {return c.ons;});
//     }
//     var local_transaction_url = document.location + '.json',
//         message;
//     $.post( local_transaction_url, params, function(data) {
//       if (data.council && data.council.name && data.council.url) {
//         button.find('a').attr('href', data.council.url);
//         button.find('span.destination').text(" on the "+ data.council.name +" website");
//         button.removeClass('hidden');
//       } else if(data.council && data.council.name && data.council.contact_address) {
//         var element = $('#authority-contact');
//         element.find("a.url").attr("href", data.council.contact_url).text(data.council.name);
//         var address = element.find("div.adr").empty();
//         for (var i = 0, l = data.council.contact_address.length; i < l; i++) {
//             address.append(data.council.contact_address[i]).append('<br>');
//         }
//         address.append(document.createElement('br'));
//         element.find('div.tel .value').text(data.council.contact_phone);
//         element.removeClass("hidden");
//         $('#no-provider-error').addClass("hidden");
//       } else {
//         message = "Sorry, we couldn't find details of a provider for that service in your area.";
//         $('#no-provider-error').text(message).removeClass('hidden');
//         $('#authority-contact').addClass("hidden");
//         $('input[name=postcode]').attr('aria-labelledby', 'no-provider-error');
//       }
//       $('#location-loading').addClass('hidden');
//     });
//   }
//   function unload_transaction() {
//     $('#no-provider-error').addClass('hidden');
//     $('#authority-contact').addClass("hidden");
//     button.addClass('hidden');
//   }
// };

// $( function() {
//   if ( $('#wrapper').attr('class').match(/local_transaction/) ) {
//     setup_local_transactions();
//   }
// });

// $(document).ready(function () {
//   var $container = $('section.more');

//   if ($container.find('.js-tabs').length) {
//     $container.tabs();
//   }
// });
