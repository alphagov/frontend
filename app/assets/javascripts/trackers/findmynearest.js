_gaq.push(['_trackEvent', 'Citizen-Format-Findmynearest', 'Load']);
$(document).ready(function() {
  // on page load, see if we have any results
  if($("#options").length != 0){
    _gaq.push(['_trackEvent', 'Citizen-Format-Findmynearest', 'Success-results']);
  }
});
