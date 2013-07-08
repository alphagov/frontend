(function($) {
  var countryWasClicked = false,
      enterKeyCode = 13;

  $(".countries-wrapper").attr("aria-live", "polite");
  $.expr[':'].contains = function(obj, index, meta){
    return (obj.textContent || obj.innerText || "").toUpperCase().indexOf(meta[3].toUpperCase()) >= 0;
  };

  var input = $("#country-filter form input#country"),
      listItems = $("ul.countries li"),
      countryHeadings = $(".inner section.countries-wrapper div").children("h2");

  var filterHeadings = function() {
    var headingHasVisibleCountries = function(headingFirstLetter) {
      return $("#" + headingFirstLetter.toUpperCase()).find("li:visible").length > 0;
    };

    countryHeadings.each(function(index, elem) {
      var $elem = $(elem), header = $elem.text().match(/[A-Z]{1}$/)[0];
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
    var itemsToHide,
        itemsShowing;

    filterHeadings();
    listItems.each(function(i, item) {
      var $item = $(item);
      var link = $item.children("a");
      $item.html(link);
    }).show();

    filter = $.trim(filter);
    if(filter && filter.length > 0) {
      itemsToHide = listItems.filter(":not(:contains(" + filter + "))");
      itemsToHide.hide();
      itemsShowing = listItems.length - itemsToHide.length;
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
      itemsShowing = listItems.length;
    }
    $(document).trigger("countrieslist", { "count" : itemsShowing });
  };

  var updateCounter = function (e, eData) {
    var $counter = $(".country-count"),
        results;

    $counter.find(".js-filter-count").text(eData.count);
    if (eData.count == 0) { // this is intentional type-conversion
      results = document.createTextNode(' results');
      $counter[0].appendChild(results);
    } else {
      $counter.html($counter.html().replace(/\sresults$/, ''));
    }
  };

  input.keyup(function() {
    var filter = $(this).val();

    filterListItems(filter);
  }).keypress(function(event) {
    if (event.which == enterKeyCode) {
      event.preventDefault();
    }
  })

  $(document).bind("countrieslist", updateCounter);
}(jQuery));
