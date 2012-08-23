/**
 * --------------------------------------------------------------------
 * jQuery tabs plugin
 * Author: Scott Jehl, scott@filamentgroup.com
 * Copyright (c) 2009 Filament Group 
 * licensed under MIT (filamentgroup.com/examples/mit-license.txt)
 * --------------------------------------------------------------------
 */
/* August 2011
 * Frances Berriman
 * Minor changes to support GovUK specific markup
*/
/* July 2012
 * Tom Byers
 * Minor changes to support Trade tariff specific markup
*/
jQuery.fn.tabs = function(settings){
	//configurable options
	var o = $.extend({
		trackState: true, //track tabs in history, url hash, back button, page load
		srcPath: 'jQuery.history.blank.html',
		autoRotate: false,
		alwaysScrollToTop: true
	},settings);
	
	return $(this).each(function(){
		//reference to tabs container
		var tabs = $(this);

		//set app mode
		//if( !$('body').is('[role]') ){ $('body').attr('role','application'); }
		
		//nav is first ul
		var tabsNav = tabs.find('.nav-tabs ul');
		
		//body is nav's next sibling
		var tabsBody = $(".tab-content");

		var tabIDprefix = 'tab-';

		var tabIDsuffix = '-enhanced';
		
		//add class to nav, tab body
		tabsNav
			.addClass('tabs-nav')
			.attr('role','tablist');
			
		tabsBody
			.addClass('tabs-body');
		
		//find tab panels, add class and aria
		tabsBody.find('.tab-pane').each(function(){
			$(this)
				.addClass('tabs-panel')
				.attr('role','tabpanel')
				.attr('aria-hidden', true)
				.attr('aria-labelledby', tabIDprefix + $(this).attr('id'))
				.attr('id', $(this).attr('id') + tabIDsuffix)
				.hide();
		});
		
		//set role of each tab
		tabsNav.find('li').each(function(){
			$(this)
				.attr('role','tab')
				.attr('id', tabIDprefix+$(this).find('a').attr('href').split('#')[1]);
		});

		//switch selected on click
    // tabsNav.find('a').attr('tabindex','-1');
		
		//generic select tab function
		function selectTab(tab,fromHashChange){
			if(o.trackState && !fromHashChange){ 
			  var anchor = tab.attr('href').split("#")[1];
				$.historyLoad(anchor); 
			}
			else{	
				//unselect tabs
				tabsNav.find('li')
					.attr('aria-selected', false)
					.filter('.active')
					.removeClass('active')
					.find('a');
				//set selected tab item	
				tab
					.parent()
					.addClass('active')
					.attr('aria-selected', true);
				//unselect  panels
				tabsBody.find('.tabs-panel-selected')
					.attr('aria-hidden',true)
					.removeClass('tabs-panel-selected')
					.hide();
					
				//select active panel
				var anchor = tab.attr('href').split("#")[1];
				$( "#" + anchor + tabIDsuffix )
					.addClass('tabs-panel-selected')
					.attr('aria-hidden',false)
					.show();

			}
		};			

			
		tabsNav.find('a')
			.click(function(){
				selectTab($(this));
				$(this).focus();
				return false;
			});
			
		//if tabs are rotating, stop them upon user events	
		tabs.bind('click keydown focus',function(){
			if(o.autoRotate){ clearInterval(tabRotator); }
		});
		
		//function to select a tab from the url hash
		function selectTabFromHash(hash){
			var currHash = hash || window.location.hash;
			if(currHash.indexOf("#") == 0){
        currHash = currHash.split("#")[1];
      }
			var hashedTab = tabsNav.find('a[href$=#'+ currHash +']');
		    if( hashedTab.size() > 0){
		    	selectTab(hashedTab,true);	
		    }
		    else {
		    	selectTab( tabsNav.find('a:first'),true);
		    }
		    //return true/false
		    return !!hashedTab.size();
		}
		
		//if state tracking is enabled, set up the callback
		if(o.trackState){ $.historyInit(selectTabFromHash, o.srcPath); }
		
		
		//set tab from hash at page load, if no tab hash, select first tab
		selectTabFromHash(null,true);

		//auto rotate tabs
		if(o.autoRotate){
			var tabRotator = setInterval(function(){
				var currentTabLI = tabsNav.find('li.active');
				var nextTab = currentTabLI.next();
				if(nextTab.length){
					selectTab(nextTab.find('a'),false );
				}
				else{
					selectTab( tabsNav.find('a:first'),false );
				}
			}, o.autoRotate);
		}
		
		if(o.alwaysScrollToTop){
			$(window)[0].scrollTo(0,0);
		}
		

	});
};
