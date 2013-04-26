/*jslint indent: 2 */
var GOVUK = GOVUK || {};
GOVUK.performance = GOVUK.performance || {};

GOVUK.performance.addToNamespace = function (name, obj) {
  if (GOVUK.performance[name] === undefined) {
    GOVUK.performance[name] = obj;
  }
};

/*jslint indent: 2 */
/*global GOVUK: true*/
/*global document: true*/
// https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Object/keys

if (!Object.keys) {
  Object.keys = (function () {
    var hasProperty = Object.prototype.hasOwnProperty,
      hasDontEnumBug = !({toString: null}).propertyIsEnumerable('toString'),
      dontEnums = [
        'toString',
        'toLocaleString',
        'valueOf',
        'hasOwnProperty',
        'isPrototypeOf',
        'propertyIsEnumerable',
        'constructor'
      ],
      dontEnumsLength = dontEnums.length;
 
    return function (obj) {
      if (typeof obj !== 'object' && typeof obj !== 'function' || obj === null) {
        throw new TypeError('Object.keys called on non-object');
      }
 
      var result = [],
        prop, i;
 
      for (prop in obj) {
        if (hasProperty.call(obj, prop)) {
          result.push(prop);
        }
      }

      if (hasDontEnumBug) {
        for (i = 0; i < dontEnumsLength; (i += 1)) {
          if (hasProperty.call(obj, dontEnums[i])) {
            result.push(dontEnums[i]);
          }
        }
      }
      return result;
    };
  }());
}

GOVUK.performance.addToNamespace("getElementsByAttributeFallback", function (attr) {
  var elements = document.getElementsByTagName('*'), i = 0, len, results = [];
  for (i = 0, len = elements.length; i < len; (i += 1)) {
    if (elements[i].getAttribute(attr)) {
      results.push(elements[i]);
    }
  }
  return results;
});

GOVUK.performance.addToNamespace("getElementsByAttribute", function (attr) {
  var results;
  
  if (document.querySelectorAll) {
    results = document.querySelectorAll('[' + attr + ']');
  } else {
    results = GOVUK.performance.getElementsByAttributeFallback(attr);
  }
  
  return results;
});

/*global document:true*/
/*global GOVUK: true*/
/*jslint indent: 2 */

GOVUK.performance.addToNamespace("cookieUtils", (function () {
  
  var cookiesAsKeyValues, getCookieNamed, setSessionCookie, deleteCookieNamed; 
  
  
  cookiesAsKeyValues = function () {
    var bakedCookies = [], rawCookies = document.cookie.split(';'), i = 0, len, keyValue;
    for (i = 0, len = rawCookies.length; i < len; (i += 1)) {
      keyValue = rawCookies[i].split('=');
      bakedCookies.push({
        key: keyValue[0].trim(),
        value: keyValue[1] ? keyValue[1].trim() : undefined
      });
    }
    return bakedCookies;
  };


  getCookieNamed = function (name) {
    var allCookies = cookiesAsKeyValues(), i = 0, len;
    for (i = 0, len = allCookies.length; i < len; (i += 1)) {
      if (allCookies[i].key === name) {
        return allCookies[i];
      }
    }
  };


  setSessionCookie = function (cookie) {
    var path = (cookie.path === undefined) ? "; Path=/" : "; Path=" + cookie.path;
    document.cookie = cookie.key + "=" + cookie.value + path;
  };


  deleteCookieNamed = function (name) {
    document.cookie = name.trim() + "=" + "deleted" + ";expires=" + new Date(0).toUTCString() + "; Path=/";
  };


  return {
    cookiesAsKeyValues: cookiesAsKeyValues,
    getCookieNamed: getCookieNamed,
    setSessionCookie: setSessionCookie,
    deleteCookieNamed: deleteCookieNamed
  };

}()));

/*global GOVUK: true*/
/*global Sizzle: true*/
/*jslint indent: 2 */

GOVUK.performance.addToNamespace("stageprompt", (function () {
  var nameOfCookie = "journey_events",
    analyticsService,
    privateMethods = {},
    setup;


  privateMethods.addStartStringToCookie = function (journeyValue) {
    var cookie = {key: nameOfCookie, value: journeyValue, path: "/"};
    GOVUK.performance.cookieUtils.setSessionCookie(cookie);
  };


  privateMethods.sendCookieEvents = function () {
    var existingCookie = GOVUK.performance.cookieUtils.getCookieNamed(nameOfCookie), events, i = 0;

    if (existingCookie && existingCookie.value) {
      analyticsService(existingCookie.value);
      GOVUK.performance.cookieUtils.deleteCookieNamed(nameOfCookie);
    }
  };

  setup = function (config) {
    /*jslint newcap: false*/
    
    analyticsService = config.analyticsFunction;
  
    privateMethods.sendCookieEvents();
  
    var nodeWithJourneyTag = GOVUK.performance.getElementsByAttribute("data-journey")[0],
      oldOnclick;
    if (nodeWithJourneyTag) {
      if (nodeWithJourneyTag.nodeName === "A") {
        oldOnclick = nodeWithJourneyTag.onclick;
        nodeWithJourneyTag.onclick = function () {
          if (oldOnclick) {
            oldOnclick();
          }
          privateMethods.addStartStringToCookie(nodeWithJourneyTag.getAttribute("data-journey"));
        };
      } 
      else if (nodeWithJourneyTag.nodeName === "BODY") {
        analyticsService(nodeWithJourneyTag.getAttribute("data-journey"));
      }
    }
  };

  return {
    setup: setup
  };
}()));

// @depend ../script/namespace.js
// @depend ../script/patch.js
// @depend ../script/cookieUtils.js
// @depend ../script/stageprompt.js

