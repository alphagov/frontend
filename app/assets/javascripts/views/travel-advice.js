(function ($) {
  jQuery.expr[':'].contains = function (obj, index, meta){
    return (obj.textContent || obj.innerText || "").toUpperCase().indexOf(meta[3].toUpperCase()) >= 0;
  };

  var headingHasVisibleCountries = function(headingFirstLetter) {
    return $("section#" + headingFirstLetter.toUpperCase()).find("li:visible").length > 0;
  };

  var input = $("form#country-filter input#country");
  var listItems = $("ul.countries li");
  var countryHeadings = $(".inner section").not(":first").children("h1");

  var filterHeadings = function() {
    countryHeadings.each(function(index, elem) {
      var $elem = $(elem),
          header = $elem.text();
      if(headingHasVisibleCountries(header)) {
        $elem.show();
      } else {
        $elem.hide();
      }
    });
  };

  input.change(function () {
    var filter = $(this).val();

    if (filter && filter.length > 0) {
      listItems.show();
      listItems.filter(":not(:contains(" + filter + "))").hide();
      filterHeadings();
    } else {
      listItems.show();
      countryHeadings.show();
    }

    return false;
  }).keyup(function () {
    $(this).change();
  });
}(jQuery));
