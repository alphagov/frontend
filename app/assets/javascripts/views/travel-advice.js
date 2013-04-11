(function($) {
  $(".countries-wrapper").attr("aria-live", "polite");
  $.expr[':'].contains = function(obj, index, meta){
    return (obj.textContent || obj.innerText || "").toUpperCase().indexOf(meta[3].toUpperCase()) >= 0;
  };

  var headingHasVisibleCountries = function(headingFirstLetter) {
    return $("section#" + headingFirstLetter.toUpperCase()).find("li:visible").length > 0;
  };

  var input = $("form#country-filter input#country"),
      listItems = $("ul.countries li"),
      countryHeadings = $(".inner section").not(":first").children("h1");

  var filterHeadings = function() {
    countryHeadings.each(function(index, elem) {
      var $elem = $(elem), header = $elem.text();
      headingHasVisibleCountries(header) ? $elem.show() : $elem.hide();
    });
  };


  var filterListItems = function(filter) {
    listItems.each(function(i, item) {
      var $item = $(item);
      var link = $item.children("a");
      $item.html(link);
    }).show();
    if(filter && filter.length > 0) {
      listItems.filter(":not(:contains(" + filter + "))").hide();
      var synonym = findSynonym(filter);
      if(synonym && synonym.country) {
        listItems.filter(":contains(" + synonym.country + ")").show().append("(" + synonym.synonym + ")");
      }
      filterHeadings();
    } else {
      countryHeadings.show();
    }
  };

  var findSynonym = function(search) {
    var country_synonyms = {
      "United States": "USA",
      "America": "USA",
      "Dubai": "United Arab Emirates",
      "UAE": "United Arab Emirates",
      "East Timor": "Timor-Leste",
      "Ivory Coast": "Côte d'Ivoire",
      "PNG": "Papua New Guinea",
      "Ibiza": "Spain"
    };

    for(var prop in country_synonyms) {
      if(prop.toLowerCase().indexOf(search.toLowerCase()) > -1) {
        return {
          synonym: prop,
          country: country_synonyms[prop]
        };
      }
    }
    return false;
  }


  input.change(function(e) {
    var filter = $(this).val();
    filterListItems(filter);
    findSynonym(filter);
    e.preventDefault();
  }).keyup(function() {
    $(this).change();
  }).keypress(function(event) {
    if (event.which == 13) {
      event.preventDefault();
    }
  });
}(jQuery));
