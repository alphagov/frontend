describe("liveSearch", function(){
  var $form, $results, $count, _supportHistory;

  beforeEach(function () {
    $form = $('<form action="/somewhere" class="js-live-search-form"><input type="checkbox" name="field" value="sheep" checked></form>');
    $results = $('<div id="js-live-search-results">my result list</div>');
    $count = $('<div id="js-live-search-result-count">294 results</div>');

    $('body').append($form).append($results).append($count);

    _supportHistory = GOVUK.support.history;
    GOVUK.support.history = function(){ return true; };
    GOVUK.liveSearch.resultCache = {};
  });

  afterEach(function(){
    $form.remove();
    $results.remove();
    $count.remove();

    GOVUK.support.history = _supportHistory;
  });

  it("should save inital state", function(){
    GOVUK.liveSearch.init();
    expect(GOVUK.liveSearch.state).toBe('field=sheep');
  });

  it("should detect a new state", function(){
    GOVUK.liveSearch.init();
    expect(GOVUK.liveSearch.isNewState()).toBe(false);
    $form.find('input').prop('checked', false);
    expect(GOVUK.liveSearch.isNewState()).toBe(true);
  });

  it("should update state to current state", function(){
    GOVUK.liveSearch.init();
    expect(GOVUK.liveSearch.state).toBe('field=sheep');
    $form.find('input').prop('checked', false);
    GOVUK.liveSearch.saveState();
    expect(GOVUK.liveSearch.state).toBe('');
  });

  it("should not request new results if they are in the cache", function(){
    GOVUK.liveSearch.resultCache["newresultlist"] = "exists";
    GOVUK.liveSearch.state = "newresultlist";
    spyOn(GOVUK.liveSearch, 'displayResults');
    spyOn(jQuery, 'ajax');

    GOVUK.liveSearch.updateResults();
    expect(GOVUK.liveSearch.displayResults).toHaveBeenCalled();
    expect(jQuery.ajax).not.toHaveBeenCalled();
  });

  it("should request new results if they aren't in the cache", function(){
    GOVUK.liveSearch.state = "notcached";
    spyOn(GOVUK.liveSearch, 'displayResults');
    var ajaxCallback = jasmine.createSpyObj('ajax', ['done']);
    spyOn(jQuery, 'ajax').andReturn(ajaxCallback);

    GOVUK.liveSearch.updateResults();
    expect(jQuery.ajax).toHaveBeenCalledWith({url: '/somewhere.json', data: 'notcached'});
    expect(ajaxCallback.done).toHaveBeenCalled();
    ajaxCallback.done.mostRecentCall.args[0]('response data')
    expect(GOVUK.liveSearch.displayResults).toHaveBeenCalled();
    expect(GOVUK.liveSearch.resultCache['notcached']).toBe('response data');
  });

  it("should show and hide loading indicator when loading new results", function(){
    GOVUK.liveSearch.state = "notcached";
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

  describe('with relevent dom nodes set', function(){
    beforeEach(function(){
      GOVUK.liveSearch.$form = $form;
      GOVUK.liveSearch.$results = $results;
      GOVUK.liveSearch.$resultCount = $count;
      GOVUK.liveSearch.state = 'field=sheep';
    });

    it("should save inital state to cache", function(){
      GOVUK.liveSearch.saveInitalState();
      expect(GOVUK.liveSearch.resultCache['field=sheep'].result_count).toBe('294');
      expect(GOVUK.liveSearch.resultCache['field=sheep'].results).toBe('my result list');
    });

    it("should update save state and update results when checkbox is changed", function(){
      spyOn(GOVUK.liveSearch, 'updateResults');
      $form.find('input').prop('checked', false);

      GOVUK.liveSearch.checkboxChange();
      expect(GOVUK.liveSearch.state).toBe('');
      expect(GOVUK.liveSearch.updateResults).toHaveBeenCalled();
    });

    it("should do nothing if state hasn't changed when a checkbox is changed", function(){
      spyOn(GOVUK.liveSearch, 'updateResults');
      GOVUK.liveSearch.checkboxChange();
      expect(GOVUK.liveSearch.state).toBe('field=sheep');
      expect(GOVUK.liveSearch.updateResults).not.toHaveBeenCalled();
    });

    it("should display results from the cache", function(){
      GOVUK.liveSearch.resultCache["thefirstone"] = {
        results: "my new results list",
        result_count: "a count of results"
      };
      GOVUK.liveSearch.state = "thefirstone";
      GOVUK.liveSearch.displayResults();

      expect($results.text()).toBe('my new results list');
      expect($count.text()).toMatch(/^a count of results/);
    });
  });
});

