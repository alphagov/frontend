$(document).ready(function() {
  
	//var selects = $("#govuk-feedback #feedback-options").html();
	
	var html = "<div id='feedback-cta' class='left'><h2>Helpful?</h2><p><a href='#' class='close' id='feedback-dismiss' title='Close'>x</a></p<form><input id='cta-yes' type='button' value='Yes' /><input id='cta-no' type='button' value='No' /></form></div>";
	$("#entry_3").val(location.href);
 	var delay = 6000; 
	
//	$("#feedback-options").append(selects);
	var popupContents = $("#govuk-feedback").html();
	$("body").append(html);
	$("#cta-yes").click(function(){
	  // send to a collection bucket
	  _gaq.push(['_trackEvent', 'Citizen-Feedback', 'Yes']);
	  $("#feedback-cta").html("<h2>Thanks for letting us know</h2>");
	  $("#feedback-cta").delay(1500).fadeOut('slow');
	  setCookie("govukfeedback","dismiss",7);
	  // set cookie to dismiss it for good
	})
  $("#cta-no").click(function(){
    _gaq.push(['_trackEvent', 'Citizen-Feedback', "No"]);
    BetaPopup.popup(popupContents, "feedback-tools");
    $("#popup h2").focus;
    $("#feedback-cta").fadeOut('fast');
    
		$("#popup form").live("submit", function(){
		  $.ajax({
        type: 'GET',
        url: this.action,
        data: $(this).serialize(),
        complete: function(){
          $("#popup form").html("<p>Thanks for your feedback</p>")
        }
      });
		  return false;
		})	
		setCookie("govukfeedback","dismiss",7)

  });
  $("#feedback-dismiss").click(function(){
    $("#feedback-cta").remove();
    _gaq.push(['_trackEvent', 'Citizen-Feedback', 'Dismiss']);
    setCookie("govukfeedback","dismiss",7);
  })
  
  if(getCookie("govukfeedback") != "dismiss"){
    $("#feedback-cta").delay(6000).fadeIn(1500);
  }
  
  function setCookie(name,value,days) {
      if (days) {
          var date = new Date();
          date.setTime(date.getTime()+(days*24*60*60*1000));
          var expires = "; expires="+date.toGMTString();
      }
      else var expires = "";
      document.cookie = name+"="+value+expires+"; path=/";
  }

  function getCookie(name) {
      var nameEQ = name + "=";
      var ca = document.cookie.split(';');
      for(var i=0;i < ca.length;i++) {
          var c = ca[i];
          while (c.charAt(0)==' ') c = c.substring(1,c.length);
          if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
      }
      return null;
  }

});