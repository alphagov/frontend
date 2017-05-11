//= require govuk/multivariate-test

var UkviABTest = UkviABTest || {};

UkviABTest.validRemainInTheUKFamily = function(pathname) {
  return (pathname.split("/").indexOf("remain-in-uk-family") > -1);
}

UkviABTest.validJoinFamilyInUK = function(pathname) {
  return (pathname.split("/").indexOf("join-family-in-uk") > -1);
}

UkviABTest.abTestLabel = function(pathname) {
  if(UkviABTest.validRemainInTheUKFamily(pathname)) {
    return "ukviSpouseVisa_Remain_2017";
  } else if (UkviABTest.validJoinFamilyInUK(pathname)) {
    return "ukviSpouseVisa_Join_2017";
  }
}

UkviABTest.validOverviewSection = function(pathname) {
  var paths = ["/remain-in-uk-family", "/remain-in-uk-family/overview", "/join-family-in-uk", "/join-family-in-uk/overview"];
  return (paths.indexOf(pathname) > -1);
}

UkviABTest.validKnowledgeOfEnglishSection = function(pathname) {
  var paths = ["/remain-in-uk-family/knowledge-of-english", "/join-family-in-uk/knowledge-of-english"];
  return (paths.indexOf(pathname) > -1);
}

UkviABTest.UpdateOverviewSection = function() {
  $("#exceptions").prevAll().hide();
  $("#exceptions").before($("#ab-test-overview").html());
}

UkviABTest.UpdateKnowledgeOfEnglishSection = function() {
  $("#exemptions").prevAll().hide();
  $("#exemptions").before($("#ab-test-knowledge-of-english").html());
}

$(function(){
  var pathname = window.location.pathname;
  var abTestLabel = UkviABTest.abTestLabel(pathname);

  if(UkviABTest.validOverviewSection(pathname)) {
    new GOVUK.MultivariateTest({
      name: abTestLabel,
      cookieDuration: 30, // set cookie expiry to 30 days
      customDimensionIndex: [13, 14],
      cohorts: {
        original: { callback: function() {}, weight: 50},
        spouseProminent: { callback: UkviABTest.UpdateOverviewSection, weight: 50}
      }
    });
  } else if (UkviABTest.validKnowledgeOfEnglishSection(pathname)) {
    new GOVUK.MultivariateTest({
      name: abTestLabel,
      cookieDuration: 30, // set cookie expiry to 30 days
      customDimensionIndex: [13, 14],
      cohorts: {
        original: { callback: function() {}, weight: 50},
        spouseProminent: { callback: UkviABTest.UpdateKnowledgeOfEnglishSection, weight: 50}
      }
    });
  }
});
