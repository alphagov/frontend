(function($) {
  $(".countries-wrapper").attr("aria-live", "polite");
  $.expr[':'].contains = function(obj, index, meta){
    return (obj.textContent || obj.innerText || "").toUpperCase().indexOf(meta[3].toUpperCase()) >= 0;
  };

  var headingHasVisibleCountries = function(headingFirstLetter) {
    return $("section#" + headingFirstLetter.toUpperCase()).find("li:visible").length > 0;
  };

  var input = $("#country-filter form input#country"),
      listItems = $("ul.countries li"),
      countryHeadings = $(".inner section").not(":first").children("h1");

  var filterHeadings = function() {
    countryHeadings.each(function(index, elem) {
      var $elem = $(elem), header = $elem.text();
      headingHasVisibleCountries(header) ? $elem.show() : $elem.hide();
    });
  };


  var doesSynonymMatch = function(elem, synonym) {
    var synonyms = $(elem).data("synonyms").split("|");
    var result = false;
    for(var syn in synonyms) {
      if(synonyms[syn].toLowerCase().indexOf(synonym.toLowerCase()) > -1) {
        result = synonyms[syn];
      }
    };
    return result;
  };

  var filterListItems = function(filter) {
    filterHeadings();
    listItems.each(function(i, item) {
      var $item = $(item);
      var link = $item.children("a");
      $item.html(link);
    }).show();

    filter = $.trim(filter);
    if(filter && filter.length > 0) {
      listItems.filter(":not(:contains(" + filter + "))").hide();
      listItems.each(function(i, item) {
        var $listItem = $(item);
        var synonym = doesSynonymMatch(item, filter);
        if(synonym) {
          $listItem.show().append("(" + synonym + ")");
        }
      });
      filterHeadings();
    } else {
      countryHeadings.show();
    }
  };


  input.change(function(e) {
    var filter = $(this).val();
    filterListItems(filter);
    e.preventDefault();
  }).keyup(function() {
    $(this).change();
  }).keypress(function(event) {
    if (event.which == 13) {
      event.preventDefault();
    }
  });
}(jQuery));
