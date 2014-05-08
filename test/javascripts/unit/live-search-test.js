describe("liveSearch", function(){
  var $form, $results, _supportHistory;
  var dummyResponse = {
    "query":"fiddle",
    "result_count_string":"1 result",
    "result_count":1,
    "results_any?":true,
    "results":[
      {"title":"my-title","link":"my-link","description":"my-description"}
    ]
  };

  beforeEach(function () {
    $form = $('<form action="/somewhere" class="js-live-search-form"><input type="checkbox" name="field" value="sheep" checked></form>');
    $results = $('<div class="js-live-search-results-block">my result list</div>');

    $('body').append($form).append($results);

    _supportHistory = GOVUK.support.history;
    GOVUK.support.history = function(){ return true; };
    GOVUK.liveSearch.resultCache = {};
  });

  afterEach(function(){
    $form.remove();
    $results.remove();

    GOVUK.support.history = _supportHistory;
  });

  it("should save inital state", function(){
    GOVUK.liveSearch.init();
    expect(GOVUK.liveSearch.state).toEqual([{name: 'field', value: 'sheep'}]);
  });

  it("should detect a new state", function(){
    GOVUK.liveSearch.init();
    expect(GOVUK.liveSearch.isNewState()).toBe(false);
    $form.find('input').prop('checked', false);
    expect(GOVUK.liveSearch.isNewState()).toBe(true);
  });

  it("should update state to current state", function(){
    GOVUK.liveSearch.init();
    expect(GOVUK.liveSearch.state).toEqual([{name: 'field', value: 'sheep'}]);
    $form.find('input').prop('checked', false);
    GOVUK.liveSearch.saveState();
    expect(GOVUK.liveSearch.state).toEqual([]);
  });

  it("should not request new results if they are in the cache", function(){
    GOVUK.liveSearch.resultCache["more=results"] = "exists";
    GOVUK.liveSearch.state = { more: "results" };
    spyOn(GOVUK.liveSearch, 'displayResults');
    spyOn(jQuery, 'ajax');

    GOVUK.liveSearch.updateResults();
    expect(GOVUK.liveSearch.displayResults).toHaveBeenCalled();
    expect(jQuery.ajax).not.toHaveBeenCalled();
  });

  it("should return a promise like object if results are in the cache", function(){
    GOVUK.liveSearch.resultCache["more=results"] = "exists";
    GOVUK.liveSearch.state = { more: "results" };
    spyOn(GOVUK.liveSearch, 'displayResults');
    spyOn(jQuery, 'ajax');

    var promise = GOVUK.liveSearch.updateResults();
    expect(typeof promise.done).toBe('function');
  });

  it("should return a promise like object if results aren't in the cache", function(){
    GOVUK.liveSearch.state = { not: "cached" };
    spyOn(GOVUK.liveSearch, 'displayResults');
    var ajaxCallback = jasmine.createSpyObj('ajax', ['done']);
    spyOn(jQuery, 'ajax').andReturn(ajaxCallback);

    GOVUK.liveSearch.updateResults();
    expect(jQuery.ajax).toHaveBeenCalledWith({url: '/somewhere.json', data: {not: "cached"}});
    expect(ajaxCallback.done).toHaveBeenCalled();
    ajaxCallback.done.mostRecentCall.args[0]('response data')
    expect(GOVUK.liveSearch.displayResults).toHaveBeenCalled();
    expect(GOVUK.liveSearch.resultCache['not=cached']).toBe('response data');
  });

  it("should show and hide loading indicator when loading new results", function(){
    GOVUK.liveSearch.state = { not: "cached" };
    spyOn(GOVUK.liveSearch, 'displayResults');
    spyOn(GOVUK.liveSearch, 'showLoadingIndicator');
    spyOn(GOVUK.liveSearch, 'hideLoadingIndicator');
    var ajaxCallback = jasmine.createSpyObj('ajax', ['done']);
    spyOn(jQuery, 'ajax').andReturn(ajaxCallback);

    GOVUK.liveSearch.updateResults();
    expect(GOVUK.liveSearch.showLoadingIndicator).toHaveBeenCalled();
    ajaxCallback.done.mostRecentCall.args[0]('response data')
    expect(GOVUK.liveSearch.hideLoadingIndicator).toHaveBeenCalled();
  });

  it("should return cache items for current state", function(){
    GOVUK.liveSearch.state = { not: "cached" };
    expect(GOVUK.liveSearch.cache()).toBe(undefined);
    GOVUK.liveSearch.cache('something in the cache');
    expect(GOVUK.liveSearch.cache()).toBe('something in the cache');
  });

  describe('with relevent dom nodes set', function(){
    beforeEach(function(){
      GOVUK.liveSearch.$form = $form;
      GOVUK.liveSearch.$resultsBlock = $results;
      GOVUK.liveSearch.state = { field: "sheep" };
    });

    it("should update save state and update results when checkbox is changed", function(){
      var promise = jasmine.createSpyObj('promise', ['done']);
      spyOn(GOVUK.liveSearch, 'updateResults').andReturn(promise);
      spyOn(GOVUK.liveSearch, 'pageTrack').andReturn(promise);
      $form.find('input').prop('checked', false);

      GOVUK.liveSearch.checkboxChange();
      expect(GOVUK.liveSearch.state).toEqual([]);
      expect(GOVUK.liveSearch.updateResults).toHaveBeenCalled();
      promise.done.mostRecentCall.args[0]();
      expect(GOVUK.liveSearch.pageTrack).toHaveBeenCalled();
    });

    it("should do nothing if state hasn't changed when a checkbox is changed", function(){
      spyOn(GOVUK.liveSearch, 'updateResults');
      GOVUK.liveSearch.checkboxChange();
      expect(GOVUK.liveSearch.state).toEqual({ field: 'sheep'});
      expect(GOVUK.liveSearch.updateResults).not.toHaveBeenCalled();
    });

    it("should display results from the cache", function(){
      GOVUK.liveSearch.resultCache["the=first"] = dummyResponse;
      GOVUK.liveSearch.state = { the: "first" };
      GOVUK.liveSearch.displayResults();

      expect($results.find('h3').text()).toBe('my-title');
      expect($results.find('#js-live-search-result-count').text()).toMatch(/^\s+1 result/);
    });

    it("should restore checkbox values", function(){
      GOVUK.liveSearch.state = [ { name: "field", value: "sheep" } ];
      GOVUK.liveSearch.restoreCheckboxes();
      expect($form.find('input').prop('checked')).toBe(true);

      GOVUK.liveSearch.state = [ ];
      GOVUK.liveSearch.restoreCheckboxes();
      expect($form.find('input').prop('checked')).toBe(false);
    });
  });
});

