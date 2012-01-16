_gaq.push(['_trackEvent', 'Citizen-Format-Answer', 'Load']);
$(document).ready(function() {
  // on an answer page for 5 seconds
  setTimeout("_gaq.push(['_trackEvent', 'Citizen-Format-Answer', 'Success-duration']);",5000);
});
