//= require govuk/multivariate-test

var UkviABTest = UkviABTest || {};

UkviABTest.isSection = function(pathname) {
  return window.location.pathname === pathname;
}

UkviABTest.AddtoApplySection = function() {
  var html = "<p>You can <a " +
   "href='https://visas-immigration.service.gov.uk/product/eea-qp'>apply online "+
   "as a qualified person</a> but not if you’re a student or self-sufficient "+
    "person and you're either:</p>"+
  "<ul>"+
    "<li>reliant on a family member for financial support</li>"+
    "<li>financially responsible for any other family members</li>"+
  "</ul>";

  $(html).insertBefore('h2:contains("Apply as a ‘family member’")');
}

UkviABTest.AddtoPermanentResidenceSection = function() {
  var html = "<p>If you're from the EEA, you can also <a "+
   "href='https://visas-immigration.service.gov.uk/product/eea-pr'>apply "+
    "online</a> but not if you’re a student or self-sufficient person and "+
    "you're either:</p>"+
  "<ul>"+
    "<li>reliant on a family member for financial support</li>"+
    "<li>financially responsible for any other family members</li>"+
  "</ul>";

  $(html).insertBefore('h3:contains("Supporting documents")');
}

$(function(){
  if(UkviABTest.isSection("/eea-registration-certificate/apply")) {
    new GOVUK.MultivariateTest({
      name: 'ukvi_apply-201609',
      customDimensionIndex: 13,
      cohorts: {
        original: { callback: function() {}, weight: 60},
        applyTextAndLink: { callback: UkviABTest.AddtoApplySection, weight: 40}
      }
    });
  }

  if(UkviABTest.isSection("/eea-registration-certificate/permanent-residence")) {
    new GOVUK.MultivariateTest({
      name: 'ukvi_permResidence-201609',
      customDimensionIndex: 13,
      cohorts: {
        original: { callback: function() {}, weight: 60},
        applyTextAndLink: { callback: UkviABTest.AddtoPermanentResidenceSection, weight: 40}
      }
    });
  }
});
